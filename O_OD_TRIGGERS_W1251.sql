/* 1.
������ �� ���������� �������� �������� str_sum ������� orders_detail
����� ���������� �������� �������� discount ������� orders
*/
create or replace trigger od_strsum_by_discount_trigger
after update discount on orders
declare
    pragma exception_init()
begin
    -- ���������� ������� orders_detail �� �������� id_order
    update orders_detail 
    set str_sum = price * qty * (1 - :new.discount / 100)
    where id_order = :old.id;
end;


/* 2.
������ �� ���������� �������� �������� amount ������� orders
����� �������, �������� ������ ��� ���������� �������� ��������� price, qty 
� ������� orders_detail 
*/
create or replace trigger orders_amount_update_trigger
after insert or update price, qty or delete on orders_detail
declare
    v_order_sum number;
    v_id_order number;
begin
    -- ����������� ���������� v_id_order � ����������� �� �������
    if inserting then 
        v_id_order = :new.id_order;
    elsif updating('price') or updating('qty') or deleting then
        v_id_order = :old.id_order;
    end if;

    -- ���������� ����� ����� �� id_order
    begin
        select sum(str_sum) into v_order_sum from orders_detail
        where id_order = v_id_order
        group by id_order;

        -- ��������� ���������� � ������ ���������� ������
        exception when no_data_found then v_order_sum = 0;
    end;

    -- ���������� ������� orders �� �������� id
    update orders
    set amount = v_order_sum
    where id = v_id_order;
end;


/* 3.
������ ��� ���������� �������� �������� str_sum ������� orders_detail
� ������ ���������� �������� �������� price ��� qty
*/
create or replace trigger od_strsum_by_price_qty_trigger
before update price, qty on orders_detail
declare
    v_discount number;
begin
    -- ������� ������ �� ������� orders �� id
    select discount into v_discount from orders
    where id = :new.id_order;

    -- ���������� ������� orders_detail �� id_order
    update orders_detail
    set str_sum = :new.price * :new:qty * (1 - v_discount / 100)
    where id_order = :new.id_order;
end;

-- ��������� �������� ��� ������ �������
alter table orders enable all triggers;
alter table orders_detail enable all triggers;