-- dannys dinner--
--case study 1--
-- questions and answers--
-- 1. What is the total amount each customer spent at the restaurant?--



select 
S.customer_id,Sum(M.price) as Total_Amount_Spent
from 
sales as S inner join menu as M 
ON S.product_id = M.product_id
group by customer_id
order by Total_Amount_Spent Desc



---2. How many days has each customer visited the restaurant?
Select
	Customer_id As Customer,
	Count(Distinct (Order_date)) As Number_of_Visits
From Sales
Group by Customer_ID
Order By Number_of_Visits Desc


--3.What was the first item from the menu purchased by each customer?
with CTE_CustomerPurchase AS (
SELECT
	Customer_id,
	Order_date,
	product_name,
	Rank()over (partition by customer_id order by Order_date ) as DateRank
From sales as S Inner join menu as m
	on s.product_id = m.Product_id
	)
	SELECT
	Customer_id,
	product_name
	From
	CTE_CustomerPurchase
	where Daterank = 1



	---4. What is the most purchased item on the menu and how many times was it purchased by all customers?

	SELECT Top 1
		Product_name,
		count(s.product_id) as Totalpurchase
	From
	sales as S Inner join menu as m
	on s.product_id = m.Product_id
	Group By
	product_name
	Order by
	Totalpurchase Desc


	---5.Which item was the most popular for each customer?
	with CTE_CustomerPurchase AS (
SELECT
	Customer_id,
	product_name,
	Count(product_name) as totalpurchase,
	rank()over (partition by customer_id order by count(product_name)Desc ) as Productranks
From sales as S Inner join menu as m
	on s.product_id = m.Product_id
	Group By
	product_name,
	customer_id
	)
	select
	Customer_id,
	product_name
	From
	CTE_CustomerPurchase
	where
	Productranks = 1
	
	
	---6. Which item was purchased first by the customer after they became a member?
With CTE_MembersPurchase As (

SELECT
	S.Customer_Id,
	Product_name,
	join_date,
	Order_date,
	RANK ()Over (Partition By S.Customer_id Order By Order_date) As PurchaseRank

From Sales As S
	INNER JOIN Menu As M On S.product_Id =M.product_Id
	INNER JOIN Members As Mem ON S. customer_id=Mem.Customer_id
Where
	Order_date >=Join_date

)
Select
	Customer_ID,
	Product_name

From
	CTE_MembersPurchase

Where
	PurchaseRank = 1


	---7.Which item was purchased just before the customer became a member?

	With CTE_MembersPurchase As (

SELECT
	S.Customer_Id,
	Product_name,
	join_date,
	Order_date,
	RANK ()Over (Partition By S.Customer_id Order By Order_date) As PurchaseRank

From Sales As S
	INNER JOIN Menu As M On S.product_Id =M.product_Id
	INNER JOIN Members As Mem ON S. customer_id=Mem.Customer_id
Where
	Order_date <=Join_date

)
Select
	Customer_ID,
	Product_name

From
	CTE_MembersPurchase

Where
	PurchaseRank = 1

	---8.What is the total items and amount spent for each member before they became a member?

	SELECT
	S.Customer_Id,
	Count(S.Product_Id) As Totalproduct,
	SUM(M.price) As TotalAmount
	
From Sales As S
	INNER JOIN Menu As M On S.product_Id =M.product_Id
	INNER JOIN Members As Mem ON S. customer_id=Mem.Customer_id
Where
	Order_date <Join_date

Group By
	S.customer_id


	---9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT
	 Customer_ID,
	 Sum(
		CASE Product_name
		When 'Sushi' Then Price* 10 * 2
		ELSE price * 10
		END) As Totalpoints
FROM
	Sales AS S
	INNER JOIN Menu As M
	On S.product_id = M.product_id
Group by
	Customer_id
Order by
	TotalPoints DESC

 


	---10. In the first week after a customer joins the program (including their join date) 
	----they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

	SELECT
	 S.Customer_ID,
	 Sum(
		CASE 
			When S. order_date Between Mem.join_date and 
			Dateadd(day,6,Mem.Join_date) Then Price* 10 * 2
			When product_name =
			'Sushi'Then price* 10*2
			ELSE price * 10
			END) As Totalpoints
FROM
	Sales AS S
	INNER JOIN Menu As M
	On S.product_id = M.product_id
	INNER JOIN Members AS Mem
	On S.Customer_id = Mem.customer_id
Where 
	Year(S.order_date) = 2021 And Month(S. order_date) =1
Group by
	S.Customer_id
Order by
	TotalPoints DESC

