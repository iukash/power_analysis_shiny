library(shiny)
library(shinyjs)
library(pwr)

shinyUI(fluidPage(
  useShinyjs(),
    h3(textOutput(outputId = "title_my"), align = "center"),
  
    #начало страницы расчета
    radioButtons("select_parametric", label = (""), inline = TRUE, choices = list(
                          "Расчет для параметрических критериев" = 1, 
                          "Прогнозирование средствами моделирования" = 2), 
              selected = 1),
    selectInput("select_test", label = h3("Выберете критерий"), choices = list("Тест Стьюдента" = 1,
                               "Тест хи-квадрат" = 2,"Тест корреляции" = 3,"Дисперсионный анализ anova" = 4)),
    h3(textOutput("output_slider_value")),
    fluidRow(
      column(6, 
             sliderInput("slider_power", label = h4 ("Мощность"), min = 0, max = 1, value = 0.9, step = 0.05)
      ),
      column(6, 
             sliderInput("slider_p_value", label = h4 ("Достоверность"), min = 0, max = 1, value = 0.05, step = 0.05)
      )
    ),
    fluidRow(
      column(6, h4(textOutput("output_effect_value")),
             radioButtons("radio_cohen", label = (""), inline = TRUE,
                          choices = list("Слабый" = 1, "Средний" = 2,"Сильный" = 3), selected = 2),
             sliderInput("slider_effect", label = (""), min = 0, max = 1, value = 0.5, step = 0.05)
      ),
      column(6, 
             sliderInput("slider_n", label = h4 ("Количество исследований"), min = 1, max = 200, value = 44, step = 1)
      )
    ),
    radioButtons("radio", label = h3("Выберите рассчитываемый параметр"), inline = TRUE,
                 choices = list("Мощность" = 1, "Достоверность" = 2,"Величина эффекта" = 3,
                                "Количество исследований" = 4), selected = 4
    ),

    h4(textOutput("output_select_dop")),
    fluidRow(
      column(6, 
             selectInput("select_type", label = h4 ("Тип"), choices = list(
               "Зависимые выборки" = 1,"Независимые выборки" = 2))
      ),
      column(6, 
             selectInput("select_alternative", label = h4 ("Направление"), choices = list(
               "Двухсторонний" = 1,"Односторонний возрастающий" = 2,"Односторонний убывающий" = 3))
      ),
      column(6, 
             sliderInput("slider_df", label = h4 ("Количество степеней свободы"), min = 1, max = 50, value = 1, step = 1)
      ),
      column(6, 
             sliderInput("slider_k", label = h4 ("Количество групп"), min = 1, max = 20, value = 3, step = 1))
  ),
      h3(textOutput("output_text"), align = "center"),
  
  #начало страницы моделирование
  h3(textOutput("output_message"), align = "center")
  )
)
