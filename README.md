## ���������� �������������� ��������, ������� ����� ������������ ������ � ����������� ������ � ��������.
***
### �������������� ����������:
  1. ��� ��������� ���� ������ (orders.discount) ������ ��������������� 
     ����� �� ������� ������ (orders_detail.str_sum).
  2. ��� ���������� ������ ������, �������� ������ ������ ��� ��������� ���� 
     ��� ���������� �� ������ ������ ������ ���������� ����� ������ (orders.amount).
  3. ��� ��������� ���� ��� ���������� �� ������ ������ ������ ��������� ��������������� ����� 
     �� ������ ������ (orders_detail.str_sum).
  4. ���� � ������ ������ orders_detail.idx ���������� ����� ������ ������������� ������������� 
     � � ��������� ����� ������ �� ������ ���� ���������. ������������������ ������ ���� ������ 1,2, � ���������� ����� ������.
  5. �������� ������ (orders.discount) ����� ����� �������� �� 0 �� 100
  6. ����� �� ������ ����������� ��������� ������� = ����(orders_detail.price)\*����������(orders_detail.qty)\* (1-������(orders.descount)/100) 
***
> �����������:
> �������� ����� ������ ��������� ����
>    orders.n_doc
>    orders.date_doc
>    orders.discount
>    orders_detail.id_order
>    orders_detail.price
>    orders_detail.qty
>    orders_detail.sku
>    ��������� ��������������� �������������.