---Cleaning data in SQl Query

select * from  protfolio_project..NashvilleHousing

---- Standandize the date

update NashvilleHousing
set SaleDate = (convert(date,SaleDate))


Alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = convert(date,SaleDate)

-----populate property address date

select ,PropertyAddress,LandUse
from protfolio_project..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
isnull(a.PropertyAddress,b.PropertyAddress)
from protfolio_project..NashvilleHousing a
join protfolio_project..NashvilleHousing b
	on a.ParcelID =b.ParcelID 
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
--order by ParcelID

update a
 set propertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from protfolio_project..NashvilleHousing a
	join protfolio_project..NashvilleHousing b
	on a.ParcelID =b.ParcelID 
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-----Breaking out the address into individual column(Address,city,state)

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as ADDRESS, 
SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as ADDRESS
FROM protfolio_project..NashvilleHousing

ALTER TABLE protfolio_project..NashvilleHousing
ADD Propertysplitaddress nvarchar(225) 

update protfolio_project..NashvilleHousing
set Propertysplitaddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE protfolio_project..NashvilleHousing
ADD Propertysplitcity nvarchar(225) 

update protfolio_project..NashvilleHousing
set Propertysplitcity = SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))


/*
OR instead of using SUBSTRING you use 'PARSENAME'
   PARSENAME(REPLACE(PropertyAddress, ',' , '.') 1)
N/B You are replacing cos parsename only looks out for period(full stop)
remember it also does it backward.
*/

select 
 parsename(replace(OwnerAddress, ',','.'),1),
 parsename(replace(OwnerAddress, ',','.'),2),
 parsename(replace(OwnerAddress, ',','.'),3)
from protfolio_project..NashvilleHousing

select * from protfolio_project..NashvilleHousing
 



----- change Y and N to YES and NO in 'soldasvacent' field----
select distinct(SoldAsVacant)
from protfolio_project..NashvilleHousing

select SoldAsVacant,
case  
	when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
from protfolio_project..NashvilleHousing


----Remove Duplicates

select *,ROW_NUMBER() over (partition by ParcelID, PropertyAddress ,SalePrice,SaleDate,LegalReference
		order by uniqueID)  Row_num
from protfolio_project..NashvilleHousing
 

 ---CTE

with HOUSING AS
(
 select *, ROW_NUMBER() over (partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
		order by uniqueID)  Row_num
from protfolio_project..NashvilleHousing
)

select Row_num from HOUSING
where Row_num > 1

----deleteing the duplicated column 

Delete Row_num from HOUSING
where Row_num > 1

---- deleting some unuseful column 
alter table protfolio_project..NashvilleHousing
drop column .....


