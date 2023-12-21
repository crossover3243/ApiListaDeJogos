
$(document).ready(function() {
  const listaJogos = $('#lista-jogos');
  const modalExclusao = $('#confirmacaoExclusaoModal');
  let jogoIdParaExcluir;

  
  listaJogos.on('click', '.excluir-jogo', function(event) {
    event.stopPropagation(); // Impede a propagação do evento para evitar o desaparecimento do botão
    jogoIdParaExcluir = $(this).data('id');
    modalExclusao.modal('show');
  });



  // Função para carregar os jogos da API e exibi-los na página
  function carregarJogos() {
    $.ajax({
      url: 'http://localhost:3333/games',
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        const listaJogos = $('#lista-jogos');
        listaJogos.empty(); // Limpa a lista antes de atualizar
        // Exibe os jogos na página
        data.forEach(function(jogo) {
          const listItem = criarEstruturaJogo(jogo);
          listaJogos.append(listItem);
        });
      },
      error: function(error) {
        console.log('Erro ao carregar os dados da API:', error);
      }
    });
  }


  // Chamada inicial para carregar os jogos ao carregar a página
  carregarJogos();

  // Evento para preencher o formulário de edição ao clicar em "Editar"
  listaJogos.on('click', '.editar-jogo', function() {
    const jogoId = $(this).data('id');

    $.ajax({
      url: `http://localhost:3333/games/${jogoId}`,
      type: 'GET',
      dataType: 'json',
      success: function(jogo) {
        $('#nome').val(jogo.nome);
        $('#descricao').val(jogo.descricao);
        $('#produtora').val(jogo.produtora);
        $('#ano').val(jogo.ano);
        $('#idadeMinima').val(jogo.idadeMinima);
        
        // Define o ID do jogo no atributo 'data-id' do formulário
        $('#form-jogo').attr('data-id', jogo.id);
      },
      error: function(error) {
        console.log(`Erro ao carregar os dados do jogo com ID ${jogoId}:`, error);
      }
    });
  });

  $('#form-jogo').submit(function(event) {
    event.preventDefault();

    const jogoId = $(this).attr('data-id'); // Obtém o ID do jogo

    const jogoEditado = {
      nome: $('#nome').val(),
      descricao: $('#descricao').val(),
      produtora: $('#produtora').val(),
      ano: parseInt($('#ano').val()),
      idadeMinima: parseInt($('#idadeMinima').val())
    };
    let url = 'http://localhost:3333/games';
    let method = 'POST';
    if (jogoId) {
      url += `/${jogoId}`;
      method = 'PUT';
    }

    $.ajax({
      url: url,
      type: method,
      contentType: 'application/json',
      data: JSON.stringify(jogoEditado),
      success: function(response) {
        carregarJogos();
        $('#form-jogo').removeAttr('data-id').trigger('reset');
      },
      error: function(error) {
        console.log('Erro ao salvar/editar o jogo:', error);
      }
    });
  });

  $('#cancelar-edicao').click(function() {
    $('#form-jogo').removeAttr('data-id').trigger('reset');
  });
   // Função para excluir um jogo
   carregarJogos();



$('#confirmarExclusaoModal').on('click', function() {
  if (jogoIdParaExcluir) {
    $.ajax({
      url: `http://localhost:3333/games/${jogoIdParaExcluir}`,
      type: 'DELETE',
      success: function(response) {
        console.log('Jogo excluído com sucesso.');
        carregarJogos(); // Recarrega a lista após a exclusão
      },
      error: function(error) {
        console.log(`Erro ao excluir o jogo com ID ${jogoIdParaExcluir}:`, error);
      }
    });

    modalExclusao.modal('hide');
    jogoIdParaExcluir = null;
  }
});

modalExclusao.on('hidden.bs.modal', function() {
  jogoIdParaExcluir = null;
});

  // Criação da estrutura de cada jogo na lista
  function criarEstruturaJogo(jogo) {
    const listItem = $('<li></li>');
    const jogoInfo = `
    <strong>${jogo.nome}</strong>
    <p><strong>Descrição:</strong> ${jogo.descricao}</p>
    <p><strong>Produtora:</strong> ${jogo.produtora}</p>
    <p><strong>Ano:</strong> ${jogo.ano}</p>
    <p><strong>Idade Mínima:</strong> ${jogo.idadeMinima}</p>
    <button class="btn btn-primary editar-jogo" data-id="${jogo.id}">Editar</button>
    <button class="btn btn-danger excluir-jogo" data-id="${jogo.id}">Apagar</button>
    `;
    listItem.html(jogoInfo);
    return listItem;
  }
  listaJogos.on('click', '.editar-jogo', function() {
    // código para editar um jogo...
    $('html, body').animate({scrollTop: 0}, 'slow'); // Rola para o topo da página
  });
  

  

  // Requisição para carregar os jogos da API e exibi-los na página
  $.ajax({
    url: 'http://localhost:3333/games',
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      listaJogos.empty(); // Limpa a lista antes de atualizar

      // Exibe os jogos na página
      data.forEach(function(jogo) {
        const jogoItem = criarEstruturaJogo(jogo);
        listaJogos.append(jogoItem);
      });
    },
    error: function(error) {
      console.log('Erro ao carregar os dados da API:', error);
    }
  });
  
});