/* 1. 5.
тригер на обновление значений атрибута str_sum таблицы orders_detail
после обновления значений атрибута discount таблицы orders
*/
create or replace trigger od_strsum_by_discount_trigger
after update of discount on orders
for each row
begin
    -- обработка исключения если discount не лежит в диапазоне 0 - 100
    if :new.discount < 0 or :new.discount > 100 then
        raise_application_error(-20001, 'Скидка не должна превышать значения 100 и быть меньше 0');
    end if;

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
after insert or update of PRICE, QTY or delete on orders_detail
for each row
declare
    v_order_sum number;
    v_id_order number;
begin
    -- определение переменной v_id_order в зависимости от команды
    if inserting then 
        v_id_order := :new.id_order;
    elsif updating('PRICE') or updating('QTY') or deleting then
        v_id_order := :old.id_order;
    end if;

    -- вычисление общей суммы по id_order
    begin
        select sum(str_sum) into v_order_sum from orders_detail
        where id_order = v_id_order;

        -- обработка исключения в случае отсутствия данных
        exception when no_data_found then v_order_sum := 0;
    end;

    -- обновление таблицы orders по атрибуту id
    update orders
    set amount = v_order_sum
    where id = v_id_order;
end;


/* 3. 4.
тригер для обновления значения атрибута str_sum таблицы orders_detail
в случае обновления значения атрибута price или qty
и добавления значения в атрибут idx в случае вставки строки
*/
create or replace trigger od_strsum_by_price_qty_trigger
before insert or update of price, qty on orders_detail
for each row
declare
    v_discount number;
    v_idx_max number;
begin
    -- определение команды тригера
    if updating('PRICE') or updating('QTY') then
        -- выборка скидки из таблицы orders по id
        select discount into v_discount from orders where id = :old.id_order;

        -- обновление таблицы orders_detail по id_order
        update orders_detail
        set str_sum = :new.price * :new.qty * (1 - v_discount / 100)
        where id_order = :old.id_order;
    elsif inserting then
        -- выборка максимального порядкового номера строки относительно номера заказа
        begin
            select max(idx) into v_idx_max from orders_detail
            where id_order = :new.id_order;

            -- обработка исключения в случае отсутствия данных
            exception when no_data_found then v_idx_max := 1;
        end;
        
        -- обновление значения idx
        :new.idx := v_idx_max;
    end if;
end;


-- активация\отсключение тригеров для каждой таблицы
/*
alter table orders disable all triggers;
alter table orders_detail disable all triggers;
alter table orders enable all triggers;
alter table orders_detail enable all triggers;
*/
