/* 1.
тригер на обновление значений атрибута str_sum таблицы orders_detail
после обновления значений атрибута discount таблицы orders
*/
create or replace trigger od_strsum_by_discount_trigger
after update discount on orders
declare
    pragma exception_init()
begin
    -- обновление таблицы orders_detail по атрибуту id_order
    update orders_detail 
    set str_sum = price * qty * (1 - :new.discount / 100)
    where id_order = :old.id;
end;


/* 2.
тригер на обновление значений атрибута amount таблицы orders
после вставки, удаления строки или обновления значений атрибутов price, qty 
в таблице orders_detail 
*/
create or replace trigger orders_amount_update_trigger
after insert or update price, qty or delete on orders_detail
declare
    v_order_sum number;
    v_id_order number;
begin
    -- определение переменной v_id_order в зависимости от команды
    if inserting then 
        v_id_order = :new.id_order;
    elsif updating('price') or updating('qty') or deleting then
        v_id_order = :old.id_order;
    end if;

    -- вычисление общей суммы по id_order
    begin
        select sum(str_sum) into v_order_sum from orders_detail
        where id_order = v_id_order
        group by id_order;

        -- обработка исключения в случае отсутствия данных
        exception when no_data_found then v_order_sum = 0;
    end;

    -- обновление таблицы orders по атрибуту id
    update orders
    set amount = v_order_sum
    where id = v_id_order;
end;


/*
тригер для обновления значения атрибута str_sum таблицы orders_detail
в случае обновления значения атрибута price или qty
*/
create or replace trigger od_strsum_by_price_qty_trigger
before update price, qty on orders_detail
declare
    v_discount number;
begin
    -- выборка скидки из таблицы orders по id
    select discount into v_discount from orders
    where id = :new.id_order;

    -- обновление таблицы orders_detail по id_order
    update orders_detail
    set str_sum = :new.price * :new:qty * (1 - v_discount / 100)
    where id_order = :new.id_order;
end;

-- активация тригеров для каждой таблицы
alter table orders enable all triggers;
alter table orders_detail enable all triggers;