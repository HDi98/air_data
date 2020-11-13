########C3
###洛杉矶到波士顿航线数据
CREATE TABLE laxtobos(select * from airdat where origin="LAX"  and dest="BOS" and Cancelled=0);
alter table laxtobos add column Delay varchar(20) not null after ArrDelay;
update laxtobos set Delay="1" where ArrDelay>0;
update laxtobos set Delay="0" where ArrDelay<=0;
select * from laxtobos limit 10;