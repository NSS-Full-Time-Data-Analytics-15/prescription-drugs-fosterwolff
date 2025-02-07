---1A
SELECT prescriber.npi , 
SUM(prescription.total_claim_count) as total_claim_sum
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
GROUP BY prescriber.npi
ORDER BY total_claim_sum DESC;
---DAVID B COFFEY

---2A
SELECT 
prescriber.specialty_description, 
SUM(prescription.total_claim_count) as total_claim_count_specialty
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
GROUP BY prescriber.specialty_description
ORDER BY total_claim_count_specialty DESC;
---FAMILY PRACTICE

---2B
SELECT prescriber.specialty_description, 
COUNT(prescription.total_claim_count) AS specialty_claim_count
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE drug.opioid_drug_flag = 'Y'
GROUP BY prescriber.specialty_description
ORDER BY specialty_claim_count DESC;
---NURSE PRACTITIONER

---2C
SELECT DISTINCT prescriber.specialty_description
FROM prescriber
LEFT JOIN prescription on prescriber.npi = prescription.npi
WHERE prescription.npi IS NULL;
---92

---2D
WITH total_claims AS (SELECT SUM(total_claim_count) AS overall_total FROM prescription)
SELECT prescriber.specialty_description, 
SUM(prescription.total_claim_count) AS specialty_claim_counts,
ROUND((SUM(prescription.total_claim_count)*100/total_claims.overall_total),2) AS specialty_percentage
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON prescription.drug_name = drug.drug_name
CROSS JOIN total_claims
GROUP BY prescriber.specialty_description, total_claims.overall_total
ORDER BY specialty_claim_counts DESC;
---FAMILY PRACTICE, INTERNAL MEDICINE 

---3A
SELECT drug.generic_name , SUM(prescription.total_drug_cost) as drug_name_total_cost
FROM prescription
INNER JOIN drug ON prescription.drug_name = drug.drug_name
GROUP BY drug.generic_name
ORDER BY drug_name_total_cost DESC;
---INSULIN GLARGINE,HUM.REC.ANLOG

---3B
SELECT drug.generic_name, ROUND((SUM(prescription.total_drug_cost)/SUM(prescription.total_day_supply)),2) AS cost_per_day
FROM prescription
INNER JOIN drug ON prescription.drug_name = drug.drug_name
GROUP BY drug.generic_name
ORDER BY cost_per_day DESC;
---CINRYZE

---4A
SELECT drug.drug_name,
CASE
WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'neither'
END AS drug_type
FROM drug;

---4B
SELECT
SUM(prescription.total_drug_cost) as drug_type_total_cost,
CASE
WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'neither'
END AS drug_type
FROM drug
INNER JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY drug_type;
---OPIOIDS

---5A
SELECT COUNT(cbsa.cbsa)
FROM cbsa
INNER JOIN population ON cbsa.fipscounty = population.fipscounty
WHERE cbsa.cbsaname ILIKE '%TN%';
---42

---5B
SELECT cbsa.cbsa , SUM(population) as fipscounty_pop
FROM cbsa
INNER JOIN population ON cbsa.fipscounty = population.fipscounty
WHERE cbsa.cbsaname ILIKE '%TN%'
GROUP BY cbsa
ORDER BY fipscounty_pop DESC;
---34980

---5C
SELECT * 
FROM
((SELECT fipscounty
FROM population)
EXCEPT
(SELECT fipscounty
FROM cbsa)) as non_cbsa_counties
INNER JOIN population ON non_cbsa_counties.fipscounty = population.fipscounty
INNER JOIN fips_county ON non_cbsa_counties.fipscounty = fips_county.fipscounty
ORDER BY population DESC;
---SEVIER

---6A
SELECT prescription.drug_name, prescription.total_claim_count
FROM prescription
WHERE prescription.total_claim_count > 3000;

---6B
SELECT * , 
CASE WHEN drug.opioid_drug_flag = 'Y' THEN 'TRUE' END AS opioid_drug_type
FROM prescription
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescription.total_claim_count > 3000;

---6C
SELECT prescriber.nppes_provider_first_name,
prescriber.nppes_provider_last_org_name,
prescription.drug_name,
prescription.total_claim_count,
CASE WHEN drug.opioid_drug_flag = 'Y' THEN 'TRUE' END AS opioid_drug_type
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescription.total_claim_count > 3000;

---7A/7B/7C
SELECT DISTINCT prescriber.npi, 
prescriber.nppes_provider_first_name, 
prescriber.specialty_description, 
drug.drug_name, 
COALESCE(prescription.total_claim_count,0) AS drug_specific_claim_count
FROM prescriber 
CROSS JOIN drug
LEFT JOIN prescription 
ON prescriber.npi = prescription.npi 
AND drug.drug_name = prescription.drug_name
WHERE prescriber.nppes_provider_city = 'NASHVILLE'
AND prescriber.specialty_description = 'Pain Management'
AND drug.opioid_drug_flag = 'Y'
ORDER BY prescriber.npi DESC;