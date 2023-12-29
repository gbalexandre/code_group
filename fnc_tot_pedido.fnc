create or replace function fnc_tot_pedido(p_pedido in number) 
  return number is
  
  v_total_pedido number(10);
begin
   
  select total_pedido into v_total_pedido from pedidos where pedido_id = p_pedido;

  return(v_total_pedido);
end fnc_tot_pedido;
/
