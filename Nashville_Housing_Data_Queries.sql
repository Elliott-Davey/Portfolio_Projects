--Project to do
--Standardising Data
--Populating property address data
--Breaking up property columns into mulitple columns
--Re writing columns for consistent data
--Removing duplicates
--Deleting unused columns
--Extra ETL exercise with stored procedures if you want to do that

SELECT *
FROM [Portfolio Projects]..Nashville_Housing

----------Changing 'Sale Date' column to different data type----------


SELECT SaleDate, CAST( SaleDate AS DATE) AS SALE_DATE_REFORMAT
FROM [Portfolio Projects]..Nashville_Housing

--Adding new column
ALTER TABLE [Portfolio Projects]..Nashville_Housing
ADD SALE_DATE_REFORMAT DATE

--Update column
UPDATE [Portfolio Projects]..Nashville_Housing
SET SALE_DATE_REFORMAT = CAST(SaleDate AS DATE)

--See changes
SELECT SALE_DATE_REFORMAT
FROM [Portfolio Projects]..Nashville_Housing


----------Populating 'PropertyAddress' column where there are nulls using existing addresses----------

SELECT ParcelID, PropertyAddress
FROM [Portfolio Projects]..Nashville_Housing
WHERE PropertyAddress is null

--Self join in order to populate 'PropertyAddress' with matchin 'Parcel_ID'----------
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) AS PROPERTY_ADDRESS_POPULATED
FROM [Portfolio Projects]..Nashville_Housing a
JOIN [Portfolio Projects]..Nashville_Housing b
ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]

--Cross table update statement where table aliases have to be used instead of normal table names
UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Projects]..Nashville_Housing a
JOIN [Portfolio Projects]..Nashville_Housing b
ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


----------Splitting Property Address into separate columns----------


SELECT PropertyAddress, OwnerAddress
FROM [Portfolio Projects]..Nashville_Housing

--Using SUBSTRING and CHARACTER INDEX to break up the address
SELECT
SUBSTRING(PropertyAddress, 1 , CHARINDEX(',' , PropertyAddress) -1) AS STREET, 
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) AS ADDRESS
FROM [Portfolio Projects]..Nashville_Housing

--Inserting substrings into new columns using ALTER and UPDATE
ALTER TABLE [Portfolio Projects]..Nashville_Housing
DROP COLUMN 
PROPERTY_ADDRESS_STREET,
PROPERTY_ADDRESS_CITY

ALTER TABLE [Portfolio Projects]..Nashville_Housing
ADD 
PROPERTY_ADDRESS_STREET NVARCHAR(255),
PROPERTY_ADDRESS_CITY NVARCHAR(255)

UPDATE [Portfolio Projects]..Nashville_Housing
SET
PROPERTY_ADDRESS_STREET = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',' , PropertyAddress) -1),
PROPERTY_ADDRESS_CITY = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))

SELECT PropertyAddress, PROPERTY_ADDRESS_STREET, PROPERTY_ADDRESS_CITY
FROM [Portfolio Projects]..Nashville_Housing

--Using PARSENAME to split 'OwnerAddress'. PARSENAME only looks for full-stops so must replace them for commas
SELECT OwnerAddress, 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [Portfolio Projects]..Nashville_Housing

--Add PARSENAME substrings to separate columns
ALTER TABLE [Portfolio Projects]..Nashville_Housing
DROP COLUMN 
OWNER_ADDRESS_STREET,
OWNER_ADDRESS_CITY,
OWNER_ADDRESS_STATE

ALTER TABLE [Portfolio Projects]..Nashville_Housing
ADD 
OWNER_ADDRESS_STREET NVARCHAR(255),
OWNER_ADDRESS_CITY NVARCHAR(255),
OWNER_ADDRESS_STATE NVARCHAR(255)

UPDATE [Portfolio Projects]..Nashville_Housing
SET
OWNER_ADDRESS_STREET = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
OWNER_ADDRESS_CITY = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
OWNER_ADDRESS_STATE = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT OWNER_ADDRESS_STREET, OWNER_ADDRESS_CITY, OWNER_ADDRESS_STATE
FROM [Portfolio Projects]..Nashville_Housing


----------Standardizing data in 'SoldasVacant' column, converting'Y' & 'N' to 'Yes' & 'No'----------


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) AS COUNT
FROM [Portfolio Projects]..Nashville_Housing
GROUP BY SoldAsVacant
ORDER BY COUNT

--Using a CASE statement to standardize the column
SELECT SoldAsVacant,
CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM [Portfolio Projects]..Nashville_Housing

--Applying normalization to new column
ALTER TABLE [Portfolio Projects]..Nashville_Housing
DROP COLUMN SOLD_AS_VACANT_STANDARDIZED

ALTER TABLE [Portfolio Projects]..Nashville_Housing
ADD SOLD_AS_VACANT_STANDARDIZED NVARCHAR(255)

UPDATE [Portfolio Projects]..Nashville_Housing
SET
SOLD_AS_VACANT_STANDARDIZED = CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

--Checking changes have been made correctly
SELECT DISTINCT(SOLD_AS_VACANT_STANDARDIZED), COUNT(SOLD_AS_VACANT_STANDARDIZED) AS COUNT
FROM [Portfolio Projects]..Nashville_Housing
GROUP BY SOLD_AS_VACANT_STANDARDIZED
ORDER BY COUNT