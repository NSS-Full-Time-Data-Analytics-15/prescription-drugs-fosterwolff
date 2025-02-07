---1
SELECT COUNT(*)
FROM (SELECT npi
FROM prescriber
EXCEPT 
SELECT npi
FROM prescription);
---4458

---2A
SELECT drug.generic_name, SUM(prescription.total_claim_count) AS drug_count
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug on prescription.drug_name = drug.drug_name
WHERE prescriber.specialty_description = 'Family Practice'
GROUP BY drug.generic_name
ORDER BY drug_count DESC
LIMIT 5;

---2B
SELECT drug.generic_name, SUM(prescription.total_claim_count) AS drug_count
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug on prescription.drug_name = drug.drug_name
WHERE prescriber.specialty_description = 'Cardiology'
GROUP BY drug.generic_name
ORDER BY drug_count DESC
LIMIT 5;

---2C
SELECT drug.generic_name, SUM(prescription.total_claim_count) AS drug_count
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug on prescription.drug_name = drug.drug_name
WHERE prescriber.specialty_description = 'Family Practice'
OR prescriber.specialty_description = 'Cardiology'
GROUP BY drug.generic_name
ORDER BY drug_count DESC
LIMIT 5;

---3A
SELECT prescriber.npi, SUM(prescription.total_claim_count) as total_claims, prescriber.nppes_provider_city
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescriber.nppes_provider_city = 'NASHVILLE'
GROUP BY prescriber.npi , prescriber.nppes_provider_city
ORDER BY total_claims DESC
LIMIT 5;

---3B
SELECT prescriber.npi, SUM(prescription.total_claim_count) as total_claims, prescriber.nppes_provider_city
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescriber.nppes_provider_city = 'MEMPHIS'
GROUP BY prescriber.npi , prescriber.nppes_provider_city
ORDER BY total_claims DESC
LIMIT 5;

---3C
SELECT prescriber.npi, SUM(prescription.total_claim_count) as total_claims, prescriber.nppes_provider_city
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescriber.nppes_provider_city = 'NASHVILLE'
OR prescriber.nppes_provider_city = 'MEMPHIS'
OR prescriber.nppes_provider_city = 'KNOXVILLE'
OR prescriber.nppes_provider_city = 'CHATTANOOGA'
GROUP BY prescriber.npi , prescriber.nppes_provider_city
ORDER BY total_claims DESC
LIMIT 20;

---4
SELECT * 
FROM 
(SELECT fips_county.county, ROUND(AVG(overdose_deaths.overdose_deaths),2) AS avg_overdoses_by_county
FROM fips_county 
INNER JOIN overdose_deaths ON fips_county.fipscounty::integer = overdose_deaths.fipscounty
GROUP BY fips_county.county) AS fips_county
WHERE avg_overdoses_by_county > (SELECT AVG(overdose_deaths.overdose_deaths) FROM overdose_deaths)
ORDER BY avg_overdoses_by_county DESC;

---5
SELECT SUM(population) AS tn_pop
FROM population
INNER JOIN fips_county ON population.fipscounty = fips_county.fipscounty
WHERE fips_county.state = 'TN';

---5B
SELECT fips_county.county, 
population.population, 
ROUND((population.population/(SELECT SUM(population.population)
FROM population 
INNER JOIN fips_county ON fips_county.fipscounty = population.fipscounty
WHERE fips_county.state = 'TN'))*100,2) AS percent_of_tn_pop
FROM fips_county
INNER JOIN population ON fips_county.fipscounty = population.fipscounty
ORDER BY percent_of_tn_pop DESC;





