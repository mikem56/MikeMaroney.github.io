-- Populate Property Address Data

SELECT *
FROM PortfolioProject.NashvilleHousing
-- WHERE PropertyAddress IS NULL
order by ParcelID;

SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.NashvilleHousing a 
JOIN PortfolioProject.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID 
WHERE a.PropertyAddress IS NULL;

UPDATE PortfolioProject.NashvilleHousing a
JOIN PortfolioProject.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress,b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;


-- Breaking Out Address into Individual columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.NashvilleHousing;
-- WHERE PropertyAddress IS NULL
-- order by ParcelID


SELECT
substr(PropertyAddress, 1, POSITION(',' IN PropertyAddress) -1) Address,
substr(PropertyAddress, POSITION(',' IN PropertyAddress) +1 , LENGTH(PropertyAddress)) Address
FROM PortfolioProject.NashvilleHousing;

ALTER TABLE PortfolioProject.NashvilleHousing
ADD PropertySplitAddress VARCHAR(50);

UPDATE PortfolioProject.NashvilleHousing
SET PropertySplitAddress = substr(PropertyAddress, 1, POSITION(',' IN PropertyAddress) -1);


ALTER TABLE PortfolioProject.NashvilleHousing
ADD PropertySplitCity VARCHAR(50);

UPDATE PortfolioProject.NashvilleHousing
SET PropertySplitCity  = substr(PropertyAddress, POSITION(',' IN PropertyAddress) +1 , LENGTH(PropertyAddress));

SELECT substring_index(substring_index(OwnerAddress, ',', 1), ',', -1),
		substring_index(substring_index(OwnerAddress, ',', 2), ',', -1),
        substring_index(substring_index(OwnerAddress, ',', 3), ',', -1)
FROM PortfolioProject.NashvilleHousing;

ALTER TABLE PortfolioProject.NashvilleHousing
ADD OwnerSplitAddress VARCHAR(50);

UPDATE PortfolioProject.NashvilleHousing
SET OwnerSplitAddress = substring_index(substring_index(OwnerAddress, ',', 1), ',', -1)


ALTER TABLE PortfolioProject.NashvilleHousing
ADD OwnerSplitCity VARCHAR(50);

UPDATE PortfolioProject.NashvilleHousing
SET OwnerSplitCity  = substring_index(substring_index(OwnerAddress, ',', 2), ',', -1)

ALTER TABLE PortfolioProject.NashvilleHousing
ADD OwnerSplitState VARCHAR(50);

UPDATE PortfolioProject.NashvilleHousing
SET OwnerSplitState = substring_index(substring_index(OwnerAddress, ',', 3), ',', -1)

SELECT *
FROM PortfolioProject.NashvilleHousing nh

-- Update SoldAsVacant to 'N' and 'Y'

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'N' THEN 'No'
	 WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 ELSE SoldAsVacant
END SoldAsVacantUpdated
FROM PortfolioProject.NashvilleHousing nh

UPDATE PortfolioProject.NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'N' THEN 'No'
	 WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 ELSE SoldAsVacant
END;

-- Remove Duplicates


WITH RowNumCTE AS
(
SELECT *, ROW_NUMBER() OVER(
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) RowNum
FROM PortfolioProject.NashvilleHousing nh
ORDER BY ParcelID
)


CREATE VIEW PortfolioProject.CleanedData AS
SELECT *, ROW_NUMBER() OVER(
PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) RowNum
FROM PortfolioProject.NashvilleHousing








