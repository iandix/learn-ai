# Multi-Layer Perceptron to predict the species of a flower 
# based on some of its physical attributes. Uses Keras API

# ------------------------------------------------------------------------------
# Getting and Loading the Data
# ------------------------------------------------------------------------------

# Load the Iris Dataset
iris <- read.csv(
  url("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"), 
  header = FALSE)

# Verify the first few items
head(iris)

# Inspect data structure
str(iris)

# Check Dimensions
dim(iris)

# ------------------------------------------------------------------------------
# Exploring the Data
# ------------------------------------------------------------------------------

# Adding names to columns
names(iris) <- c("Sepal.Length", "Sepal.Width", "Petal.Length", 
                 "Petal.Width", "Species")

library(corrplot)

# Computing the correlation matrix
M <- cor(iris[,1:4])

# Plotting the correlation matrix
corrplot(M, method = "circle")
corrplot(M, method = "number")

library(ggvis)

# Show positive correlation of 0.96 between petal length and width
iris %>% ggvis(~Petal.Length, ~Petal.Width, fill = ~Species) %>%
  layer_points()

# Show negative correlation of -0.11 betweem sepal lenght and width
iris %>% ggvis(~Sepal.Length, ~Sepal.Width, fill = ~Species) %>%
  layer_points()

# ------------------------------------------------------------------------------
# Preprocessing the Data
# ------------------------------------------------------------------------------

# Converting from Factor labels to numbers
iris[,5] <- as.numeric(iris[,5]) - 1

# Turning Iris into a matrix (matrices are purely numeric)
iris <- as.matrix(iris)

# Removing column labels by setting Iris 'dimnames' to 'NULL'
dimnames(iris) <- NULL

library(keras)

# Summarizing the data before normalization
summary(iris)
hist(iris, main = "Before Normalization")

# Normalizing the data
iris_norm <- normalize(iris[,1:4], -1, 2)

# Summarizing the new normalized dataset
summary(iris_norm)
hist(iris_norm, main = "After Normalization")

# ------------------------------------------------------------------------------
# Spliting Training and Test Sets
# ------------------------------------------------------------------------------

# Create a vector of indices 1 and 2 with 2/3 of 1's and 1/3 of 2's
ind <- sample(2, nrow(iris), replace = TRUE, prob = c(0.67, 0.33))

# Use indices to select data and compose training and test sets
iris.training.X <- iris[ind == 1, 1:4]
iris.test.X <- iris[ind == 2, 1:4]

# Also, split the labeled attribute
iris.training.y <- iris[ind == 1, 5]
iris.test.y <- iris[ind == 2, 5]

head(ind)
head(ind == 2)

# One hot encoding the training target values
iris.training.y.onehot <- to_categorical(iris.training.y)

# One hot encoding the test target values
iris.test.y.onehot <- to_categorical(iris.test.y)

# Printing out exemplary test data after one hot
print(head(iris.test.y.onehot))

# ------------------------------------------------------------------------------
# Constructing the Machine Learning Model
# ------------------------------------------------------------------------------

# Initializing the sequential model
model <- keras_model_sequential()

# Adding layers to the model
model %>%
  layer_dense(units = 8, activation = 'relu', input_shape = c(4)) %>%
  layer_dense(units = 3, activation = 'softmax')

# Printing summary info for the model
summary(model)

# Getting model configuration
get_config(model)

# Getting layer configuration
get_layer(model, index = 1)

# Listing model's layers
model$layers

# Listing input tensors
model$inputs

# Listing the output tensors
model$outputs

# ------------------------------------------------------------------------------
# Compiling and Training the ML Model
# ------------------------------------------------------------------------------

# Compiling the model
model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = 'rmsprop',
  metrics = 'accuracy'
)

# Training the model 
history <- model %>% 
  fit(
    iris.training.X, 
    iris.training.y.onehot, 
    epochs = 300, 
    batch_size = 8, 
    validation_split = 0.2
  )
plot(history)

# Plotting model loss for training data
plot(history$metrics$loss, main="Model Loss", xlab = "epoch", ylab="loss", col="blue", type="l")

# Plotting model loss for test data
lines(history$metrics$val_loss, col="green")

# Adding legend
legend("topright", c("train","test"), col=c("blue", "green"), lty=c(1,1))

# Plotting accuracy for training data 
plot(history$metrics$acc, main="Model Accuracy", xlab = "epoch", ylab="accuracy", col="blue", type="l")

# Plotting accuracy for validation data
lines(history$metrics$val_acc, col="green")

# Add Legend
legend("bottomright", c("train","test"), col=c("blue", "green"), lty=c(1,1))

# ------------------------------------------------------------------------------
# Evaluating Model Performance
# ------------------------------------------------------------------------------

# Evaluate on test data and labels
score <- model %>% 
  evaluate(iris.test.X, iris.test.y.onehot, batch_size = 128)

# Print the score
print(score)

# ------------------------------------------------------------------------------
# Predicting with the Model
# ------------------------------------------------------------------------------

# Predicting classes for test data
classes <- model %>% 
  predict_classes(iris.test.X, batch_size = 128)

# Printing the Confusion Matrix
table(iris.test.y, classes)
