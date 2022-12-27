/* 1. 5.
������ �� ���������� �������� �������� str_sum ������� orders_detail
����� ���������� �������� �������� discount ������� orders
*/
create or replace trigger od_strsum_by_discount_trigger
after update of discount on orders
for each row
begin
    -- ��������� ���������� ���� discount �� ����� � ��������� 0 - 100
    if :new.discount < 0 or :new.discount > 100 then
        raise_application_error(-20001, '������ �� ������ ��������� �������� 100 � ���� ������ 0');
    end if;

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
after insert or update of PRICE, QTY or delete on orders_detail
for each row
declare
    v_order_sum number;
    v_id_order number;
begin
    -- ����������� ���������� v_id_order � ����������� �� �������
    if inserting then 
        v_id_order := :new.id_order;
    elsif updating('PRICE') or updating('QTY') or deleting then
        v_id_order := :old.id_order;
    end if;

    -- ���������� ����� ����� �� id_order
    begin
        select sum(str_sum) into v_order_sum from orders_detail
        where id_order = v_id_order;

        -- ��������� ���������� � ������ ���������� ������
        exception when no_data_found then v_order_sum := 0;
    end;

    -- ���������� ������� orders �� �������� id
    update orders
    set amount = v_order_sum
    where id = v_id_order;
end;


/* 3. 4.
������ ��� ���������� �������� �������� str_sum ������� orders_detail
� ������ ���������� �������� �������� price ��� qty
� ���������� �������� � ������� idx � ������ ������� ������
*/
create or replace trigger od_strsum_by_price_qty_trigger
before insert or update of price, qty on orders_detail
for each row
declare
    v_discount number;
    v_idx_max number;
begin
    -- ����������� ������� �������
    if updating('PRICE') or updating('QTY') then
        -- ������� ������ �� ������� orders �� id
        select discount into v_discount from orders where id = :old.id_order;

        -- ���������� ������� orders_detail �� id_order
        update orders_detail
        set str_sum = :new.price * :new.qty * (1 - v_discount / 100)
        where id_order = :old.id_order;
    elsif inserting then
        -- ������� ������������� ����������� ������ ������ ������������ ������ ������
        begin
            select max(idx) into v_idx_max from orders_detail
            where id_order = :new.id_order;

            -- ��������� ���������� � ������ ���������� ������
            exception when no_data_found then v_idx_max := 1;
        end;
        
        -- ���������� �������� idx
        :new.idx := v_idx_max;
    end if;
end;


-- ���������\����������� �������� ��� ������ �������
/*
alter table orders disable all triggers;
alter table orders_detail disable all triggers;
alter table orders enable all triggers;
alter table orders_detail enable all triggers;
*/
