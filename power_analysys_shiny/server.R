library(shiny)

shinyServer(function(input, output, session) {
  observe({
    #Выбор способа расчета
    if(input$select_parametric == 1)
    {
    #Скрыл выбор параметрической/непараметрической статистики
    shinyjs::hide(id = "select_parametric");
      
    #Скрытие элементов страницы моделирование
    shinyjs::hide(id = "output_message");
      
    #Отображение элементов страницы расчета
    shinyjs::show(id = "select_test"); shinyjs::show(id = "slider_power"); shinyjs::show(id = "slider_p_value");
    shinyjs::show(id = "radio_cohen"); shinyjs::show(id = "slider_effect"); shinyjs::show(id = "slider_n");
    shinyjs::show(id = "radio"); shinyjs::show(id = "select_type"); shinyjs::show(id = "select_alternative");
    shinyjs::show(id = "slider_df"); shinyjs::show(id = "slider_k"); shinyjs::show(id = "output_select_dop");
    shinyjs::show(id = "output_effect_value"); shinyjs::show(id = "output_slider_value"); shinyjs::show(id = "output_text");
    
    #Привязка текста к элементам
    output$title_my <- renderText({"Математический расчет количества/мощности/достоверности/количественного эффекта исследований"})
    output$output_select_dop <- renderText({"Выберите дополнительные параметры для выбранного теста"})
    output$output_effect_value <- renderText({"Величина эффекта"})
    output$output_slider_value <- renderText({"Выберите значения параметров"})
    
    #получение значений со слайдеров количества/мощности/достоверности/количественного эффекта
    input.n <- input$slider_n; input.d <- input$slider_effect; 
    input.p_value <- input$slider_p_value;input.power <- input$slider_power; 
    input.type <- ifelse(input$select_type==1,{"paired"},{"two.sample"})
    input.alternative <- ifelse(input$select_alternative==1, {"two.sided"}, 
                                ifelse(input$select_alternative==2,{"greater"},{"less"}))
    input.slider_df <- input$slider_df
    input.slider_k <- input$slider_k
    
    #активность слайдеров количества/мощности/достоверности/количественного эффекта в зависимости от выбранного
    #рассчитываемого параметра
    if(input$radio == 1){
      shinyjs::disable('slider_power'); shinyjs::enable('slider_p_value'); 
      shinyjs::enable('slider_effect'); shinyjs::enable('slider_n');
      text_rezult <- "мощность"
      
      #применение выбранного теста
      if (input$select_test == 1) {
        rez_test <- pwr.t.test(n = input.n, d = input.d, sig.level = input.p_value, power = NULL,
                               type = input.type, alternative = input.alternative)}
      if (input$select_test == 2) {
        rez_test <- pwr.chisq.test(w = input.d, N = input.n, df = input.slider_df, sig.level = input.p_value, power = NULL)}
      if (input$select_test == 3) {
        rez_test <- pwr.r.test(n = input.n, r = input.d, sig.level = input.p_value, power = NULL, 
                               alternative = input.alternative)}
      if (input$select_test == 4) {
        rez_test <- pwr.anova.test(k = input.slider_k, n = input.n, f = input.d, sig.level = input.p_value, power = NULL)}
      
      text_rezult <- paste(text_rezult,round(rez_test$power,3))
    }
    if(input$radio == 2){
      shinyjs::enable('slider_power'); shinyjs::disable('slider_p_value'); 
      shinyjs::enable('slider_effect'); shinyjs::enable('slider_n');
      text_rezult <- "достоверность"
      
      #применение выбранного теста
      if (input$select_test == 1) {
        rez_test <- pwr.t.test(n = input.n, d = input.d, sig.level = NULL, power = input.power,
                               type = input.type, alternative = input.alternative)}
      if (input$select_test == 2) {
        rez_test <- pwr.chisq.test(w = input.d, N = input.n, df = input.slider_df, sig.level = NULL, power = input.power)}
      if (input$select_test == 3) {
        rez_test <- pwr.r.test(n = input.n, r = input.d, sig.level = NULL, power = input.power, 
                               alternative = input.alternative)}
      if (input$select_test == 4) {
        rez_test <- pwr.anova.test(k = input.slider_k, n = input.n, f = input.d, sig.level = NULL, power = input.power)}
      
      text_rezult <- paste(text_rezult,round(rez_test$sig.level,3))
    }
    if(input$radio == 3){
      shinyjs::enable('slider_power'); shinyjs::enable('slider_p_value'); 
      shinyjs::disable('slider_effect'); shinyjs::enable('slider_n');
      text_rezult <- "величина эффекта"
      
      #применение выбранного теста
      if (input$select_test == 1) {
        rez_test <- pwr.t.test(n = input.n, d = NULL, sig.level = input.p_value, power = input.power,
                               type = input.type, alternative = input.alternative)
        text_rezult <- paste(text_rezult,round(rez_test$d,3))}
      if (input$select_test == 2) {
        rez_test <- pwr.chisq.test(w = NULL, N = input.n, df = input.slider_df, sig.level = input.p_value, power = input.power)
        text_rezult <- paste(text_rezult,round(rez_test$w,3))}
      if (input$select_test == 3) {
        rez_test <- pwr.r.test(n = input.n, r = NULL, sig.level = input.p_value, power = input.power, 
                               alternative = input.alternative)
        text_rezult <- paste(text_rezult,round(rez_test$r,3))}
      if (input$select_test == 4) {
        rez_test <- pwr.anova.test(k = input.slider_k, n = input.n, f = NULL, sig.level = input.p_value, power = input.power)
        text_rezult <- paste(text_rezult,round(rez_test$f,3))}
    }
    if(input$radio == 4){
      shinyjs::enable('slider_power'); shinyjs::enable('slider_p_value'); 
      shinyjs::enable('slider_effect'); shinyjs::disable('slider_n');
      text_rezult <- "количество необходимых исследований"
      
      #применение выбранного теста
      if (input$select_test == 1) {
        rez_test <- pwr.t.test(n = NULL, d = input.d, sig.level = input.p_value, power = input.power,
                               type = input.type, alternative = input.alternative)
        text_rezult <- paste(text_rezult,as.integer(round(rez_test$n,0)))}
      if (input$select_test == 2) {
        rez_test <- pwr.chisq.test(w = input.d, N = NULL, df = input.slider_df, sig.level = input.p_value, power = input.power)
        text_rezult <- paste(text_rezult,as.integer(round(rez_test$N,0)))}
      if (input$select_test == 3) {
        rez_test <- pwr.r.test(n = NULL, r = input.d, sig.level = input.p_value, power = input.power, 
                               alternative = input.alternative)
        text_rezult <- paste(text_rezult,as.integer(round(rez_test$n,0)))}
      if (input$select_test == 4) {
        rez_test <- pwr.anova.test(k = input.slider_k, n = NULL, f = input.d, sig.level = input.p_value, power = input.power)
        text_rezult <- paste(text_rezult,as.integer(round(rez_test$n,0)))}
    }
    
    #ТЕСТ t критерий Стьюдента 
    if(input$select_test == 1) {
      #Отображение/скрытие дополнительных параметров для теста
      shinyjs::show(id = "select_alternative"); shinyjs::show(id = "select_type")
      shinyjs::hide(id = "slider_df"); shinyjs::hide(id = "slider_k")
      
      #Выбор величины Эффекта по Коэну
      if(input$radio_cohen==1) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "t", size = "small")$effect.size,min = 0, max = 1, step = 0.05)}
      if(input$radio_cohen==2) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "t", size = "medium")$effect.size,min = 0, max = 1, step = 0.05)}
      if(input$radio_cohen==3) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "t", size = "large")$effect.size,min = 0, max = 1, step = 0.05)}
    }
    
    #ТЕСТ хи-квадрат
    if(input$select_test == 2) {
      #Отображение/скрытие дополнительных параметров для теста
      shinyjs::hide(id = "select_alternative"); shinyjs::hide(id = "select_type")
      shinyjs::hide(id = "slider_k"); shinyjs::show(id = "slider_df")
      
      #Выбор величины Эффекта по Коэну
      if(input$radio_cohen==1) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "chisq", size = "small")$effect.size,min = 0, max = 1, step = 0.05)}
      if(input$radio_cohen==2) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "chisq", size = "medium")$effect.size,min = 0, max = 1, step = 0.05)}
      if(input$radio_cohen==3) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "chisq", size = "large")$effect.size,min = 0, max = 1, step = 0.05)}
    }
    
    #Тест корреляции
    if(input$select_test == 3) {
      #Отображение/скрытие дополнительных параметров для теста
      shinyjs::hide(id = "select_type"); shinyjs::hide(id = "slider_k")
      shinyjs::hide(id = "slider_df"); shinyjs::show(id = "select_alternative");
      
      #Выбор величины Эффекта по Коэну
      if(input$radio_cohen==1) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "r", size = "small")$effect.size,min = 0, max = 1, step = 0.05)}
      if(input$radio_cohen==2) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "r", size = "medium")$effect.size,min = 0, max = 1, step = 0.05)}
      if(input$radio_cohen==3) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "r", size = "large")$effect.size,min = 0, max = 1, step = 0.05)}
    }
    
    #Дисперсионный анализ anova
    if(input$select_test == 4) {
      #Отображение/скрытие дополнительных параметров для теста
      shinyjs::hide(id = "select_alternative"); shinyjs::hide(id = "select_type")
      shinyjs::hide(id = "slider_df"); shinyjs::show(id = "slider_k")
      
      #Выбор величины Эффекта по Коэну
      if(input$radio_cohen==1) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "anov", size = "small")$effect.size,min = 0, max = 1, step = 0.05)}
      if(input$radio_cohen==2) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "anov", size = "medium")$effect.size,min = 0, max = 1, step = 0.05)}
      if(input$radio_cohen==3) {updateSliderInput(session, "slider_effect", 
                                                  value = cohen.ES(test = "anov", size = "large")$effect.size,min = 0, max = 1, step = 0.05)}
    }
    
    output$output_text <- renderText({text_rezult})
    }
    else
    {
    #Скрытие элементов страницы расчета
    shinyjs::hide(id = "select_test"); shinyjs::hide(id = "slider_power"); shinyjs::hide(id = "slider_p_value");
    shinyjs::hide(id = "radio_cohen"); shinyjs::hide(id = "slider_effect"); shinyjs::hide(id = "slider_n");
    shinyjs::hide(id = "radio"); shinyjs::hide(id = "select_type"); shinyjs::hide(id = "select_alternative");
    shinyjs::hide(id = "slider_df"); shinyjs::hide(id = "slider_k"); shinyjs::hide(id = "output_select_dop");
    shinyjs::hide(id = "output_effect_value"); shinyjs::hide(id = "output_slider_value"); shinyjs::hide(id = "output_text");
    
    #Отображение элементов страницы моделирования
    shinyjs::show(id = "output_message");
    
    #Привязка текста к элементам
    output$title_my <- renderText({"Прогнозирование количества исследований средствами математического моделирования"})
    output$output_message <- renderText({"ПОКА НЕ СДЕЛАНО, НО СДЕЛАЮ!!!"})
    }
    
  })
})
