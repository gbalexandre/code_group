create or replace noneditionable trigger trg_itens_pedido
  after insert
  on ITENS_PEDIDO 
  for each row
declare
  -- local variables here
  v_total_itens number(10,2);
begin
  select  preco  into v_total_itens from produtos where produto_id = :new.produto_id;
  
  update pedidos set total_pedido = total_pedido + (v_total_itens * :new.quantidade) where pedido_id = :new.pedido_id;
  
end trg_itens_pedido;
/
