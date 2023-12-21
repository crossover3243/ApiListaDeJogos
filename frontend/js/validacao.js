$(document).ready(function() {
    $('#form-jogo').validate({
      rules: {
        nome: {
          required: true
        },
        descricao: {
            required: true
          },
        produtora: {
          required: true
        },
        ano: {
          required: true,
          min: 1971,
          max: 2024
        },
        idadeMinima: {
          required: true
        }
      },
      messages: {
        nome: {
          required: "Por favor, insira o nome."
        },
        descricao: {
            required: "A descrição é obrigatória"
          },
        produtora: {
          required: "Por favor, insira a produtora."
        },
        ano: {
          required: "Por favor, insira o ano.",
          min: "O ano deve ser no mínimo 1971.",
          max: "O ano deve ser no máximo 2024."
        },
        idadeMinima: {
          required: "Por favor, insira a idade mínima."
        }
      },
      errorElement: "div",
      errorPlacement: function(error, element) {
        error.addClass("invalid-feedback");
        error.insertAfter(element);
      },
      highlight: function(element, errorClass, validClass) {
        $(element).addClass("is-invalid").removeClass("is-valid");
      },
      unhighlight: function(element, errorClass, validClass) {
        $(element).addClass("is-valid").removeClass("is-invalid");
      }
    });
  });