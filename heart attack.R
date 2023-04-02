# Load required libraries
library(dplyr)
library(ggplot2)
library(caret)

# Read data from CSV
heart <- read.csv("heart.csv", header = TRUE)

# Print first 10 rows
head(heart, 10)
nrow(heart)
# Delete duplicate rows
heart <- distinct(heart)
nrow(heart)
# Calculate average age
average_age <- mean(heart$age)
cat("Average age:", average_age, "\n")

# Calculate percentage of male patients
percentage_male <- mean(heart$sex == 1) * 100
cat("Percentage of male patients:", percentage_male, "%\n")

# Count patients with higher chance of heart attack
heart_attack_count <- sum(heart$output == 1)
cat("Number of patients with higher chance of heart attack:", heart_attack_count, "\n")

# Calculate correlation between age and cholesterol level
correlation_age_chol <- cor(heart$age, heart$chol)
cat("Correlation between age and cholesterol level:", correlation_age_chol, "\n")

# Linear regression model for predicting maximum heart rate based on age
model <- lm(thalachh ~ age, data = heart)
summary(model)

# Residual plots
plot(model)

# Manually create a list of numerical variable names
numerical_vars <- c("age", "trtbps", "chol", "thalachh", "oldpeak")

# Function to plot the distribution of each numerical variable
plot_distribution <- function(variable) {
  ggplot(heart, aes_string(x = variable)) +
    geom_histogram(color = "black", fill = "lightblue", bins = 30) +
    theme_minimal() +
    labs(title = paste("Distribution of", variable),
         x = variable,
         y = "Frequency")
}

# Loop through the numerical variables and plot their distribution
for (var in numerical_vars) {
  print(plot_distribution(var))
}

# Plot heat map of different values for every numerical variable in the list
# Calculate the correlation matrix for numerical variables
cor_matrix <- cor(heart[, numerical_vars])

# Melt the correlation matrix for plotting
melted_cor_matrix <- melt(cor_matrix)

# Plot the heat map
ggplot(data = melted_cor_matrix, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, limit = c(-1, 1), name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  coord_fixed() +
  ggtitle("Heatmap of Correlation between Numerical Variables") +
  xlab("Numerical Variables") +
  ylab("Numerical Variables")



# Create a list of categorical variables manually
categorical_vars <- c("sex", "cp", "fbs", "restecg", "exng", "slp", "caa", "thall", "output")

# Function to plot the distribution of different values for a categorical variable
plot_categorical_distribution <- function(data, var_name) {
  ggplot(heart, aes_string(x = var_name)) +
    geom_bar() +
    labs(title = paste("Distribution of", var_name),
         x = var_name,
         y = "Frequency") +
    theme_minimal()
}

# Loop through the categorical variables list and plot the distribution
for (var in categorical_vars) {
  plot <- plot_categorical_distribution(heart, var)
  print(plot)
}

# Manually put all categorical variables in a list, except for the outcome column
categorical_vars <- c("sex", "cp", "fbs", "restecg", "exng", "slp", "caa", "thall")

# 3. Plot the proportion of different values for every categorical variable in the list in the output column
for (var in categorical_vars) {
  # Calculate proportion of different values of categorical variables within each output group
  proportions <- heart %>%
    group_by(output, !!sym(var)) %>%
    summarise(count = n()) %>%
    mutate(percentage = count / sum(count) * 100)
  
  # Plot the proportions for the current categorical variable
  p <- ggplot(proportions, aes(x = output, y = percentage, fill = factor(!!sym(var)))) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = paste("Proportion of", var, "by Output"),
         x = "Output",
         y = "Percentage",
         fill = var) +
    theme_minimal() +
    scale_fill_discrete(name = var) +
    scale_x_continuous(breaks = c(0, 1), labels = c("Lower Chance", "Higher Chance")) +
    coord_cartesian(ylim = c(0, 100)) +
    geom_text(aes(label = round(percentage, 1)), position = position_dodge(width = 0.9), vjust = -0.5) +
    theme(legend.position = "bottom")
  print(p)
}



# Manually put all numerical variables in a list, except for the outcome column
numerical_vars <- c("age", "trtbps", "chol", "thalachh", "oldpeak")

# Plot the distribution of different values for every numerical variable in the list in the output column
for (var in numerical_vars) {
  # Plot the distribution for the current numerical variable
  print(ggplot(heart, aes_string(x = var, fill = "factor(output)")) +
    geom_histogram(position = "identity", alpha = 0.5, bins = 30) +
    labs(title = paste("Distribution of", var, "by Output"),
         x = var,
         y = "Frequency",
         fill = "Output") +
    theme_minimal() +
    scale_fill_discrete(name = "Output", labels = c("Lower Chance", "Higher Chance")) +
    theme(legend.position = "top"))
}
 

# Train the model to predict whether a patient had a heart attack
# Create a train-test split
heart$output <- as.factor(heart$output)
set.seed(61)
trainIndex <- createDataPartition(heart$output, p = 0.75, list = FALSE)
train_set <- heart[trainIndex, ]
test_set <- heart[-trainIndex, ]

# Train the model using RandomForest algorithm
model <- train(output ~ ., data = train_set, method = "rf", trControl = trainControl(method = "cv", number = 5))

# Evaluate the model using classification report
predictions <- predict(model, newdata = test_set)
conf_matrix <- confusionMatrix(predictions, test_set$output)
conf_matrix
cat("Classification Report\n")
cat("Confusion Matrix:\n")
print(conf_matrix$table)
cat("Accuracy:", conf_matrix$overall["Accuracy"], "\n")
cat("Kappa:", conf_matrix$overall["Kappa"], "\n")
cat("Sensitivity:", conf_matrix$byClass["Sensitivity"], "\n")
cat("Specificity:", conf_matrix$byClass["Specificity"], "\n")
cat("Positive Predictive Value:", conf_matrix$byClass["Pos Pred Value"], "\n")
cat("Negative Predictive Value:", conf_matrix$byClass["Neg Pred Value"], "\n")



