---1
SELECT prescriber.specialty_description, 
SUM(prescription.total_claim_count)
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescriber.specialty_description = 'Interventional Pain Management' 
OR prescriber.specialty_description = 'Pain Management'
GROUP BY prescriber.specialty_description;

---2
SELECT NULL AS specialty_description, 
SUM(prescription.total_claim_count)
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescriber.specialty_description = 'Interventional Pain Management' 
OR prescriber.specialty_description = 'Pain Management'
UNION
SELECT prescriber.specialty_description, 
SUM(prescription.total_claim_count)
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescriber.specialty_description = 'Interventional Pain Management' 
OR prescriber.specialty_description = 'Pain Management'
GROUP BY prescriber.specialty_description;

---3
SELECT prescriber.specialty_description, 
SUM(prescription.total_claim_count)
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescriber.specialty_description = 'Interventional Pain Management' 
OR prescriber.specialty_description = 'Pain Management'
GROUP BY GROUPING SETS ((prescriber.specialty_description),());

---4
SELECT prescriber.specialty_description,
drug.opioid_drug_flag,
SUM(prescription.total_claim_count)
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescriber.specialty_description = 'Interventional Pain Management' 
OR prescriber.specialty_description = 'Pain Management'
GROUP BY GROUPING SETS ((prescriber.specialty_description),
(drug.opioid_drug_flag),
());

---5
SELECT prescriber.specialty_description,
drug.opioid_drug_flag,
SUM(prescription.total_claim_count)
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescriber.specialty_description = 'Interventional Pain Management' 
OR prescriber.specialty_description = 'Pain Management'
GROUP BY ROLLUP(drug.opioid_drug_flag,prescriber.specialty_description);

---6
SELECT prescriber.specialty_description,
drug.opioid_drug_flag,
SUM(prescription.total_claim_count)
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescriber.specialty_description = 'Interventional Pain Management' 
OR prescriber.specialty_description = 'Pain Management'
GROUP BY ROLLUP(prescriber.specialty_description,drug.opioid_drug_flag);

---7
SELECT prescriber.specialty_description,
drug.opioid_drug_flag,
SUM(prescription.total_claim_count)
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescriber.specialty_description = 'Interventional Pain Management' 
OR prescriber.specialty_description = 'Pain Management'
GROUP BY CUBE(prescriber.specialty_description,drug.opioid_drug_flag);

---8
SELECT prescriber.nppes_provider_city,
SUM(CASE WHEN drug.generic_name ILIKE '%codeine%' THEN prescription.total_claim_count END) AS codeine,
SUM(CASE WHEN drug.generic_name ILIKE '%fentanyl%' THEN prescription.total_claim_count END) AS fentanyl,
SUM(CASE WHEN drug.generic_name ILIKE '%hydrocodone%' THEN prescription.total_claim_count END) AS hydrocodone,
SUM(CASE WHEN drug.generic_name ILIKE '%morphine%' THEN prescription.total_claim_count END) AS morphine,
SUM(CASE WHEN drug.generic_name ILIKE '%oxycodone%' THEN prescription.total_claim_count END) AS oxycodone,
SUM(CASE WHEN drug.generic_name ILIKE '%oxymorphone%' THEN prescription.total_claim_count END) AS oxymorphone
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE (prescriber.nppes_provider_city = 'NASHVILLE'
OR prescriber.nppes_provider_city = 'MEMPHIS'
OR prescriber.nppes_provider_city = 'KNOXVILLE'
OR prescriber.nppes_provider_city = 'CHATTANOOGA')
AND drug.opioid_drug_flag = 'Y'
GROUP BY prescriber.nppes_provider_city






























