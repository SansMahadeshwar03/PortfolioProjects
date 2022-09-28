SELECT * 
FROM PortfolioProject..HousingData

--Changing Date format

SELECT SaleDateNew, SaleDate
FROM PortfolioProject..HousingData

UPDATE PortfolioProject..HousingData
SET SaleDate = CONVERT(date, SaleDate)

ALTER Table PortfolioProject..HousingData
ADD SaleDateNew date

UPDATE PortfolioProject..HousingData
SET SaleDateNew = CONVERT(date, SaleDate)

--Updating address


SELECT * 
FROM PortfolioProject..HousingData
WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID,a.PropertyAddress,  b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..HousingData a
JOIN PortfolioProject..HousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
--order by ParcelID
WHere a.PropertyAddress is null


UPDATE a 
SET a.PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..HousingData a
JOIN PortfolioProject..HousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
WHere a.PropertyAddress is null

--Seperating Address

SELECT PropertyAddress,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
FROM PortfolioProject..HousingData

Alter Table PortfolioProject..HousingData
Add Property_address nvarchar(255)

Update PortfolioProject..HousingData
SET Property_address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


SELECT Property_address_city
FROM PortfolioProject..HousingData

Alter Table PortfolioProject..HousingData
Add Property_address_city nvarchar(255)

Update PortfolioProject..HousingData
SET Property_address_city = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

--Separate Owner Address
SELECT PARSENAME(Replace(OwnerAddress,',','.'),3),
 PARSENAME(Replace(OwnerAddress,',','.'),2),
 PARSENAME(Replace(OwnerAddress,',','.'),1)
FROM PortfolioProject..HousingData

Alter Table PortfolioProject..HousingData
Add OwnerAddress_1 nvarchar(255)

Update PortfolioProject..HousingData
Set OwnerAddress_1 = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table PortfolioProject..HousingData
Add OwnerAddress_2 nvarchar(255)

Update PortfolioProject..HousingData
Set OwnerAddress_2 = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table PortfolioProject..HousingData
Add OwnerAddress_3 nvarchar(255)

Update PortfolioProject..HousingData
Set OwnerAddress_3 = PARSENAME(Replace(OwnerAddress,',','.'),1)



--Change Y and N to Yes and No in SoldAsVacant
SELECT DISTINCT(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject..HousingData
Group by SoldAsVacant
order by 2


SELECT SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END
From PortfolioProject..HousingData

Update PortfolioProject..HousingData
SET SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END


--Deleting duplicates
WITH RowNum_temp AS(
SELECT *,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
			    PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				UniqueID)
				row_num
From PortfolioProject..HousingData
)
SELECT* from RowNum_temp
WHERE row_num > 1
ORDER BY PropertyAddress


--Deleting old columns

Alter Table PortfolioProject..HousingData
Drop COLUMN SaleDate, OwnerAddress, PropertyAddress

SELECT * 
From PortfolioProject..HousingData

	

