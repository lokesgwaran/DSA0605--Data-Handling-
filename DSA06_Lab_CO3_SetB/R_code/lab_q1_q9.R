# DSA06 Lab Experiment CO3 - Set B : Questions 1-9 (R)
## Q1
e <- faithful$eruptions
summary(e); IQR(e); quantile(e, c(0.1, 0.9))
par(mfrow = c(1, 3)); for (k in c(5, 15, 40)) hist(e, breaks = k, col = "lightblue", main = paste("breaks =", k), xlab = "Eruption time (min)"); par(mfrow = c(1, 1))
plot(density(e, adjust = 0.5), col = "red", ylim = c(0, 0.6), xlab = "Eruption time (min)", main = "Density of eruptions")
lines(density(e, adjust = 1), col = "black"); lines(density(e, adjust = 2), col = "blue")
legend("topright", legend = paste("adjust =", c(0.5, 1, 2)), col = c("red","black","blue"), lty = 1)
## Q2
boxplot(count ~ spray, data = InsectSprays, col = "lightblue", xlab = "Spray", ylab = "Insect count")
b <- boxplot(count ~ spray, data = InsectSprays, plot = FALSE); b$stats; b$out; b$group
boxplot(count ~ spray, data = InsectSprays, outline = FALSE)
stripchart(count ~ spray, data = InsectSprays, vertical = TRUE, method = "jitter", add = TRUE, pch = 16, col = "firebrick")
par(mfrow = c(1, 2)); qqnorm(islands, main = "qqnorm(islands)"); qqline(islands, col = "red")
qqnorm(log(islands), main = "qqnorm(log(islands))"); qqline(log(islands), col = "red"); par(mfrow = c(1, 1))
## Q3
mag <- quakes$mag; summary(mag)
hist(mag, breaks = seq(3.95, 6.45, by = 0.1), col = "lightblue", xlab = "Magnitude", main = "Magnitude of quakes")
nclass.Sturges(mag); nclass.scott(mag); nclass.FD(mag)
## Q4
bw.nrd0(precip); bw.SJ(precip)
plot(density(precip), main = "density(precip)", xlab = "Annual rainfall (inches)"); rug(precip)
plot(density(precip, kernel = "gaussian"), ylim = c(0, 0.042), main = "Kernel choice")
lines(density(precip, kernel = "rectangular"), col = "red"); lines(density(precip, kernel = "epanechnikov"), col = "blue")
plot(density(precip), xlim = c(-10, 80)); lines(density(precip, from = 0), col = "red", lty = 2)
## Q5
hist(rivers, freq = FALSE, breaks = seq(0, 4000, 200), col = "lightblue", xlab = "River length (miles)", main = "Histogram of rivers")
lines(density(rivers), lwd = 2); abline(v = mean(rivers), col = "red", lwd = 2); abline(v = median(rivers), col = "blue", lwd = 2, lty = 2)
legend("topright", legend = c("mean", "median"), col = c("red", "blue"), lty = c(1, 2), lwd = 2)
skew <- function(x) { d <- x - mean(x); mean(d^3) / mean(d^2)^1.5 }
skew(rivers); skew(log(rivers))
## Q6
se <- iris$Sepal.Length[iris$Species == "setosa"]; ve <- iris$Sepal.Length[iris$Species == "versicolor"]
br <- seq(4, 7.5, by = 0.25)
hist(se, breaks = br, col = rgb(1, 0, 0, 0.4), xlim = c(4, 7.5), xlab = "Sepal length (cm)", main = "Setosa vs versicolor")
hist(ve, breaks = br, col = rgb(0, 0, 1, 0.4), add = TRUE)
legend("topright", legend = c("setosa", "versicolor"), fill = c(rgb(1,0,0,0.4), rgb(0,0,1,0.4)))
hist(se, breaks = br, plot = FALSE)$counts; hist(ve, breaks = br, plot = FALSE)$counts
## Q7
plot(NULL, xlim = c(0.5, 3.5), ylim = range(PlantGrowth$weight), xaxt = "n", xlab = "Group", ylab = "Dried weight")
axis(1, at = 1:3, labels = levels(PlantGrowth$group)); cols <- c("#8dd3c7", "#fb8072", "#80b1d3")
for (i in 1:3) { w <- PlantGrowth$weight[PlantGrowth$group == levels(PlantGrowth$group)[i]]; d <- density(w, cut = 0)
  polygon(c(i - 0.4 * d$y / max(d$y), rev(i + 0.4 * d$y / max(d$y))), c(d$x, rev(d$x)), col = cols[i]) }
boxplot(weight ~ group, data = PlantGrowth, add = TRUE, boxwex = 0.1, col = "white", xaxt = "n", outline = FALSE)
## Q8
months <- 5:9; names(months) <- c("May","Jun","Jul","Aug","Sep")
plot(NULL, xlim = c(50, 100), ylim = c(0, 5.6), yaxt = "n", xlab = "Temperature (F)", ylab = "", main = "Ridgeline plot of Temp")
for (i in seq_along(months)) { d <- density(airquality$Temp[airquality$Month == months[i]], from = 50, to = 100)
  polygon(c(d$x, rev(d$x)), c(i - 1 + 30 * d$y, rep(i - 1, length(d$x))), col = rgb(i / 6, 0.4, 1 - i / 6, 0.7)) }
axis(2, at = 0:4, labels = names(months), las = 1)
tapply(airquality$Temp, airquality$Month, mean); tapply(airquality$Temp, airquality$Month, sd)
## Q9
set.seed(7); a <- rnorm(50); b <- runif(50); d <- rt(50, df = 3)
par(mfrow = c(1, 3)); qqnorm(a, main = "a: rnorm(50)"); qqline(a, col = "red")
qqnorm(b, main = "b: runif(50)"); qqline(b, col = "red"); qqnorm(d, main = "d: rt(50, df = 3)"); qqline(d, col = "red")
set.seed(11); x50 <- rt(50, df = 10); x5000 <- rt(5000, df = 10); shapiro.test(x50); shapiro.test(x5000)
