# DSA06 Lab Experiment CO2 - Set B : Questions 1-8 (R)
# Run each block in RStudio; use Plots > Export to save pictures.

## Q1
ua <- as.matrix(USArrests[1:10, ])
t1 <- sort(rowSums(VADeaths))
barplot(t1, horiz = TRUE, las = 1, col = "steelblue", xlab = "Total death rate (per 1000)",
        ylab = "Age group", main = "Total Death Rate by Age Group (VADeaths)")
barplot(t(VADeaths), beside = TRUE, legend.text = TRUE, main = "Grouped")
barplot(t(VADeaths), legend.text = TRUE, main = "Stacked")
heatmap(scale(ua), Rowv = NA, Colv = NA, scale = "none")

## Q2
hair <- margin.table(HairEyeColor, 1); he <- margin.table(HairEyeColor, c(1, 2))
pct <- round(100 * hair / sum(hair), 1)
pie(hair, labels = paste0(names(hair), " ", pct, "%"), col = c("black","saddlebrown","firebrick","gold"), clockwise = TRUE)
barplot(prop.table(he, 2) * 100, col = c("black","saddlebrown","firebrick","gold"),
        legend.text = rownames(he), xlab = "Eye colour", ylab = "Percent")

## Q3
lang <- c(Tamil = 78, Hindi = 65, English = 88, French = 40, German = 35, Japanese = 22, Spanish = 50)
dotchart(sort(lang), pch = 19, xlim = c(0, 100), xlab = "Students enrolled", main = "Language Course Enrolment")
grid(nx = NULL, ny = NULL, col = "lightgray")
s <- sort(lang)
plot(s, 1:7, xlim = c(0, 100), yaxt = "n", pch = 19, cex = 1.5, col = "firebrick", xlab = "Students enrolled", ylab = "", main = "Lollipop Chart")
segments(0, 1:7, s, 1:7, col = "grey"); points(s, 1:7, pch = 19, cex = 1.5, col = "firebrick")
axis(2, at = 1:7, labels = names(s), las = 1)
dotchart(sort(lang), xlim = c(20, 90), pch = 19)
barplot(sort(lang), horiz = TRUE, xlim = c(20, 90), las = 1, xpd = FALSE)

## Q4
adm <- matrix(c(420,380,250,190, 450,360,300,230), nrow = 4,
              dimnames = list(c("CSE","ECE","MECH","CIVIL"), c("2024","2025")))
bp <- barplot(t(adm), beside = TRUE, col = c("#4472C4","#ED7D31"), ylim = c(0, 520),
              xlab = "Department", ylab = "Admissions", main = "Admissions by Department, 2024 vs 2025")
text(bp, t(adm) + 15, labels = t(adm))
legend("topright", legend = colnames(adm), fill = c("#4472C4","#ED7D31"), title = "Year")
round((adm[, "2025"] / adm[, "2024"] - 1) * 100, 1)
plot(NA, xlim = c(0.5, 2.5), ylim = c(150, 480), xaxt = "n", xlab = "", ylab = "Admissions")
axis(1, at = 1:2, labels = c("2024","2025"))
for (i in 1:4) segments(1, adm[i,1], 2, adm[i,2], col = ifelse(adm[i,2] < adm[i,1], "red", "darkgreen"))
points(rep(1,4), adm[,1], pch = 19); points(rep(2,4), adm[,2], pch = 19); text(0.9, adm[,1], rownames(adm), pos = 2)

## Q5
mix <- matrix(c(55,20,15,10, 50,22,18,10, 45,25,20,10), nrow = 4,
              dimnames = list(c("Coal","Solar","Wind","Hydro"), c("2022","2023","2024")))
bp <- barplot(mix, col = c("grey40","gold","steelblue","aquamarine3"), legend.text = rownames(mix), ylab = "Share (%)", main = "Electricity Mix (%)")
cs <- apply(mix, 2, cumsum); mid <- cs - mix / 2
text(rep(bp, each = 4), as.vector(mid), labels = as.vector(mix))
barplot(t(mix), beside = TRUE, legend.text = colnames(mix), ylab = "Share (%)")

## Q6
aq <- aggregate(cbind(Ozone, Solar.R, Wind, Temp) ~ Month, data = airquality, FUN = mean)
m <- scale(aq[, -1]); pal <- colorRampPalette(c("#2166ac","white","#b2182b"))(50)
image(1:4, 1:5, t(m[5:1, ]), col = pal, axes = FALSE, xlab = "", ylab = "")
axis(1, at = 1:4, labels = colnames(m)); axis(2, at = 1:5, labels = c("Sep","Aug","Jul","Jun","May"), las = 1)
for (i in 1:5) for (j in 1:4) text(j, 6 - i, round(m[i, j], 2), cex = 0.8)
nrow(airquality) - sum(complete.cases(airquality))   # rows dropped = 42

## Q7
web <- sort(c(Search = 42, Direct = 23, Social = 18, Email = 9, Referral = 6, Ads = 2), decreasing = TRUE)
pie(web, labels = paste0(names(web), " ", web, "%"), clockwise = TRUE, init.angle = 90, col = rainbow(6))
barplot(rev(web), horiz = TRUE, las = 1, col = "steelblue", xlab = "Share of traffic (%)")

## Q8
tm <- data.frame(school = c("Engg","Engg","Engg","Medical","Medical","Law"),
                 dept = c("CSE","ECE","MECH","MBBS","Dental","LLB"), budget = c(40,25,15,30,20,10))
tot <- sum(tm$budget); cols <- c(Engg = "#a6cee3", Medical = "#b2df8a", Law = "#fdbf6f")
plot(NULL, xlim = c(0,1), ylim = c(0,1), axes = FALSE, xlab = "", ylab = ""); x0 <- 0
for (s in unique(tm$school)) {
  g <- tm[tm$school == s, ]; w <- sum(g$budget) / tot; y0 <- 0
  for (i in 1:nrow(g)) {
    h <- g$budget[i] / sum(g$budget)
    rect(x0, y0, x0 + w, y0 + h, col = cols[s], border = "white", lwd = 2)
    text(x0 + w/2, y0 + h/2, paste0(g$dept[i], "\n", round(100 * g$budget[i] / tot, 1), "%"))
    y0 <- y0 + h
  }
  x0 <- x0 + w
}
