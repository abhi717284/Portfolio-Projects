-- Exploratory Data Analysis

SELECT *
FROM layoffs_abhi2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_abhi2;

SELECT * 
FROM layoffs_abhi2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_abhi2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT SUBSTRING(`date`, 1, 7) as `MONTH`, SUM(total_laid_off)
FROM layoffs_abhi2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 2 DESC;

WITH Company_year AS
(ROLLING_TOTAL
SELECT SUBSTRING(`date`, 1, 7) as `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_abhi2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) as rolling_total
FROM ROLLING_TOTAL;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_abhi2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year (company, years, total_laid_off) AS 
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_abhi2
GROUP BY company, YEAR(`date`)
), Company_year_rank AS 
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE ranking <= 5;