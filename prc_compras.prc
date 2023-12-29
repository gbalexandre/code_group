create or replace noneditionable procedure prc_compras(p_cliente     in number
                                        ,p_id_produto      in number
                                        ,p_quantidade in number
                                        ,p_sql_cod    out number
                                        ,p_erro       out varchar2) is
--Declaração de Variavel
    v_id_cliente        number;
    v_id_produto        number;
    v_pedido_id         number;
    v_itens_pedido      number;
    
begin

     --Consulta se o cliente existe
     begin
       select cliente_id  into v_id_cliente from clientes where cliente_id = p_cliente;
     exception
       when no_data_found then
         p_sql_cod := -2000;
         p_erro    := substr('Cliente nao encontrado',1,2000);
         return;
     end;
     --Consulta se o produto existe
     begin
       select produto_id    into v_id_produto from produtos where produto_id  = p_id_produto;
     exception
       when no_data_found then
         p_sql_cod := -2001;
         p_erro    := substr('Produto nao encontrado',1,2000);
         return;
     end;
     
     --Consulta para selecionar o ultimo pedido incluido e adicionar mais 1 para o insert da tabela
     select nvl(max(pedido_id),0) + 1 into v_pedido_id from pedidos; --Poderia ser criado uma sequencia e usar o returnig para selecionar para o insert da itens pedido; 
     
     --Insert da Tabela pedidos
     begin
       insert into pedidos values (v_pedido_id,v_id_cliente,sysdate,0); --campo total de pedido será preenchido pela trigger criada na tabela  itens_pedido
     exception 
       when others then
         p_sql_cod := -2002;
         p_erro := substr('Erro insert pedidos - '||sqlerrm,1,2000);       
         rollback;
         return;  
     end;

     --Consulta para selecionar o ultimo item de pedido incluido e adicionar mais 1 para o insert da tabela
     select nvl(max(item_id),0 ) + 1 into v_itens_pedido from itens_pedido; 

     --Insert da Tabela itens_pedido
     begin
       insert into itens_pedido values (v_itens_pedido,v_pedido_id,v_id_produto,p_quantidade); 
     exception 
       when others then
         p_sql_cod := -2003;
         p_erro := substr('Erro insert pedidos - '||sqlerrm,1,2000);
         rollback;
         return;       
     end;
     
     commit;

exception
  when others then
  p_sql_cod := sqlcode;
  p_erro    := sqlerrm;
  rollback;
end prc_compras;
/
