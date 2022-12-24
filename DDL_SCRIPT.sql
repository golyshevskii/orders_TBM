-- ������� � �������
CREATE TABLE sku
(
  ID          NUMBER,
  NAME        VARCHAR2(200) not null
);

COMMENT ON TABLE sku IS '������� ������� �������.';

COMMENT ON COLUMN sku.id IS '��������� ����';

COMMENT ON COLUMN sku.name IS '�������� ������.';


ALTER TABLE sku ADD (
  CONSTRAINT pk_sku
  PRIMARY KEY
  (id));

-- ������� ������
CREATE TABLE orders
(
  ID          NUMBER,
  N_DOC       NUMBER,
  DATE_DOC    DATE,
  AMOUNT      NUMBER,
  DISCOUNT    NUMBER
);


COMMENT ON TABLE orders IS '������� ���������� ������.';

COMMENT ON COLUMN orders.id IS '��������� ����';

COMMENT ON COLUMN orders.n_doc IS '� ������.';

COMMENT ON COLUMN orders.date_doc IS '���� ������.';

COMMENT ON COLUMN orders.amount IS '����� ������ ��������� �������� (����� ������� ������).';

COMMENT ON COLUMN orders.discount IS '������ � ��������� �� 0 �� 100.';


ALTER TABLE orders ADD (
  CONSTRAINT pk_orders
  PRIMARY KEY
  (id));

CREATE TABLE orders_detail
(
  ID          NUMBER,
  ID_ORDER    NUMBER not null,
  ID_SKU      NUMBER not null,
  PRICE       NUMBER,
  QTY         NUMBER,
  STR_SUM     NUMBER,
  IDX         NUMBER 
);

COMMENT ON TABLE orders_detail IS '������� ���������� ������.';

COMMENT ON COLUMN orders_detail.id IS '��������� ����';

COMMENT ON COLUMN orders_detail.id_order IS '������������� ������';

COMMENT ON COLUMN orders_detail.id_sku IS '������������� ������';

COMMENT ON COLUMN orders_detail.price IS '���� ������ �� �������.';

COMMENT ON COLUMN orders_detail.qty IS '���-�� ������.';

COMMENT ON COLUMN orders_detail.str_sum IS '����� �� ������ � ������ ������.';

COMMENT ON COLUMN orders_detail.idx IS '���������� ����� ������ ������ (�� ������ ���� ���������).';


ALTER TABLE orders_detail ADD (
  CONSTRAINT pk_orders_detail
  PRIMARY KEY
  (id));
  
  
ALTER TABLE orders_detail ADD (
  CONSTRAINT fk_orders_detail_sku 
  FOREIGN KEY (id_sku) 
  REFERENCES sku (id)
  ENABLE VALIDATE,
  CONSTRAINT fk_orders_detail_order 
  FOREIGN KEY (id_order) 
  REFERENCES orders (id)
  ENABLE VALIDATE);
