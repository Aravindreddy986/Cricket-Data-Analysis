# Give the chart file a name.
jpeg(file = "A:/ADBMS/Project/analysis/tree.jpeg")


# Basic Scatterplot Matrix
pairs(~.,data=analysist1,
      main="Simple Scatterplot Matrix")

# Create the tree.
output.tree <- ctree( result~., data = analysist1)

# Plot the tree.
plot(output.tree)

# Save the file.
dev.off()

