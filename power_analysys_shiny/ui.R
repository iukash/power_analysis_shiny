library(shiny)
library(shinyjs)
library(pwr)

shinyUI(fluidPage(
  useShinyjs(),
  titlePanel(h2("Расчет количества/мощности/достоверности/количественного эффекта исследований", align = "center")),
  mainPanel(
    selectInput("select_test", label = h3("Выберете критерий"), choices = list(
      "Тест Стьюдента" = 1,"Тест хи-квадрат" = 2,"Тест корреляции Пирсона" = 3)),
    h3("Выберите значения параметров"),
    fluidRow(
      column(6, 
             sliderInput("slider_power", label = h4 ("Мощность"), min = 0, max = 1, value = 0.9, step = 0.05)
      ),
      column(6, 
             sliderInput("slider_p_value", label = h4 ("Достоверность"), min = 0, max = 1, value = 0.05, step = 0.05)
      )
    ),
    fluidRow(
      column(6, h4 ("Величина эффекта"),
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
    #br(),
    h4("Выберите дополнительные параметры для выбранного теста"),
    fluidRow(
      column(6, 
             selectInput("select_type", label = h4 ("Тип"), choices = list(
               "Зависимые выборки" = 1,"Независимые выборки" = 2))
      ),
      column(6, 
             selectInput("select_alternative", label = h4 ("Направление"), choices = list(
               "Двухсторонний" = 1,"Односторонний возрастающий" = 2,"Односторонний убывающий" = 3))
      )
    ),
    fluidRow(
      column(6, 
             h4("РЕЗУЛЬТАТ РАСЧЕТА"),
      ),
      column(6, 
             textOutput("output_text")
      )
    ),
    
  )  
  )
)
