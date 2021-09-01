/* Cleaning the data */

select *
from PortfolioProject.dbo.NashvilleHousing

/* Standardizing the Date format */

select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

Alter Table NashvilleHousing
ADD SaleDateConverted Date;

update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

/* Populate	Property Address data */

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

/* Breaking Address Into Address, City, State */

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

from PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
ADD PropertySplitAdress nvarchar(255);

update  PortfolioProject..NashvilleHousing
SET PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table  PortfolioProject..NashvilleHousing
ADD PropertySplitCity nvarchar(255);

update  PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


/* Splitting Owner Address */

select
PARSENAME(Replace(OwnerAddress, ',','.'), 3),
PARSENAME(Replace(OwnerAddress, ',','.'), 2),
PARSENAME(Replace(OwnerAddress, ',','.'), 1)
from PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
ADD OwnerSplitAdress nvarchar(255);

update  PortfolioProject..NashvilleHousing
SET OwnerSplitAdress = PARSENAME(Replace(OwnerAddress, ',','.'), 3)

Alter Table  PortfolioProject..NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

update  PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.'), 2)

Alter Table  PortfolioProject..NashvilleHousing
ADD OwnerSplitState nvarchar(255);

update  PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'), 1)

/* Change Y to yes and N to no in SoldASVacant column */

select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant

select SoldAsVacant, 
Case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
from PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
SET SoldAsVacant =  Case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End

-- Delete Unused Columns
Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

