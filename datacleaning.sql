/*	cleaning data in SQL */

Select * 
From Portfolioproject.dbo.Nashvillehouses

-----------------------------------------------
/* standadrdize date format */

Select SaleDateConverted, CONVERT(Date, Saledate) 
From Portfolioproject.dbo.Nashvillehouses


Update Nashvillehouses
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHouses 
Add SaleDateConverted Date;

Update Nashvillehouses
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- populate address data

Select *
From Portfolioproject.dbo.Nashvillehouses
--WHERE PropertyAddress is NULL
ORDER by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolioproject.dbo.Nashvillehouses a
JOIN Portfolioproject.dbo.Nashvillehouses b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolioproject.dbo.Nashvillehouses a
JOIN Portfolioproject.dbo.Nashvillehouses b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


-- breaking address into different columns


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From Portfolioproject.dbo.Nashvillehouses


ALTER TABLE NashvilleHouses 
Add Propertysplitadd Nvarchar(255);

ALTER TABLE NashvilleHouses 
Add Propertysplitcity Nvarchar(255);

Update Nashvillehouses
SET Propertysplitadd = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Update Nashvillehouses
SET Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))



Select OwnerAddress
FROM Portfolioproject.dbo.Nashvillehouses


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM Portfolioproject.dbo.Nashvillehouses




ALTER TABLE NashvilleHouses 
Add Ownersplitadd Nvarchar(255);

ALTER TABLE NashvilleHouses 
Add Ownersplitcity Nvarchar(255);

ALTER TABLE NashvilleHouses 
Add Ownersplitstate Nvarchar(255);

Update Nashvillehouses
SET Ownersplitadd = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Update Nashvillehouses
SET Ownersplitcity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Update Nashvillehouses
SET Ownersplitstate = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)




--update y and n to yes and no in vacant sold



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
From Portfolioproject.dbo.Nashvillehouses

Update Nashvillehouses
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END




	
-- Remove duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID) row_num

From Portfolioproject.dbo.Nashvillehouses
)
Select * 
From RowNumCTE
Where row_num > 1
ORDER BY PropertyAddress
--DELETE
--FROM RowNumCTE
--WHERE row_num > 1

select * 
From Portfolioproject.dbo.Nashvillehouses


--deleting unused data

ALTER TABLE Portfolioproject.dbo.Nashvillehouses
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate