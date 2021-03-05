-- Distância máxima em que os markers permanecerão visíveis na tela
-- Caso o jogador se afaste demais dos markers, eles não serão mais
-- renderizados. Isso é utilizado para poupar computação no cliente
viewDistance = 50

-- Tamanho do elemento de colisão usado para detectar se alguma coisa
-- entrou no marker ou saiu
colliderSize = 2

-- Cores dos ícones e a base circular dos markers
-- Essas cores serão aplicadas a todos os markers, a não ser que
-- dentro de algum deles esteja especificado uma cor diferente nas
-- configurações 'iconColor' e 'baseColor'
colors = {
    icon = tocolor(255, 255, 255),
    base = tocolor(255, 255, 255)
}

-- Tamanho dos elementos na unidade de medida do GTA
sizes = {
    icon = 1,
    base = 1.1
}

-- Configuração da animação do marker
animation = {
    duration = 1000,
    easing = "InOutQuad",
    pulseMultiplier = 0.3
}

-- Tabela que guarda o caminho até a imagem .png de cada ícone
-- Essa configuração aceita dois formatos: você pode inserir
-- o nome do ícone e o caminho até a imagem, ou apenas a seu
-- nome. Caso você insira apenas o nome o script assumirá que
-- a imagem é um .png no caminho 'assets/icons' e com o nome
-- <nome_do_icone>.png
--
-- Exemplos:
--
-- ["nome"] = "caminho/para/imagem.png"
-- "nome"
icons = {
    ["base"] = "assets/base.png",
    "home"
}

-- Lista de todos os markers que aparecerão no mundo.
-- É necessário seguir estritamente o mesmo formato do exemplo:
--
-- {
--     icon = "home",                           -- Nome do ícone
--     position = { x = 0, y = 0, z = 3 },      -- Coordenadas para a posição do marker
--     dimension = 0,                           -- Dimensão do marker
--     interior = 0                             -- Interior do marker,
--     iconColor = tocolor(255, 255, 255),      -- Cor do ícone
--     baseColor = tocolor(255, 255, 255)       -- Cor da base
-- }
markers = {
    -- {
    --     icon = "home",
    --     position = { x = 0, y = 0, z = 3 },
    --     dimension = 0,
    --     interior = 0
    -- }
}
