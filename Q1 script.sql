select paymentdate, format(paymentdate, '%Y-%m-%d') from payments;
select datepart(yyyy,paymentdate) from payments;

SELECT DATE_FORMAT('2009-10-04 22:23:00', '%W %M %Y');
SELECT DATE_FORMAT(paymentdate, '%Y, %M %d') from payments;