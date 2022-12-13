/* cleaning data in sql queries

*/

SELECT * FROM 
dataCleaningPortfolio.dbo.nashvillehousing

--standardize date format

SELECT saledate, convert(date, saledate) 
FROM 
dataCleaningPortfolio.dbo.nashvillehousing

update dbo.nashvillehousing
set saledate = sale_date

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--populate property address data

select *
from dbo.nashvillehousing where propertyaddress is null
order by parcelid

select a.parcelid, b.parcelid, a.uniqueid, b.uniqueid, isnull(a.parcelid, b.parcelid)
from datacleaningportfolio.dbo.nashvillehousing a
join datacleaningportfolio.dbo.nashvillehousing b
on a.parcelid= b.parcelid
and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null

update a
set propertyaddress= isnull(a.parcelid, b.parcelid)
from datacleaningportfolio.dbo.nashvillehousing a
join datacleaningportfolio.dbo.nashvillehousing b
on a.parcelid= b.parcelid
and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From dataCleaningPortfolio.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From dataCleaningPortfolio.dbo.NashvilleHousing


ALTER TABLE dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From datacleaningportfolio.dbo.NashvilleHousing



Select OwnerAddress
From dataCleaningPortfolio.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From dataCleaningPortfolio.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From dataCleaningPortfolio.dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dataCleaningPortfolio.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From dataCleaningPortfolio.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   -- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From dataCleaningPortfolio.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From dataCleaningPortfolio.dbo.NashvilleHousing


-- Delete Unused Columns



Select *
From dataCleaningPortfolio.dbo.NashvilleHousing


ALTER TABLE dataCleaningPortfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




