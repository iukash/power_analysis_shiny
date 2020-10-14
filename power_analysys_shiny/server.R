library(shiny)

shinyServer(function(input, output, session) {
  observe({
    if(input$radio_cohen==1) {updateSliderInput(session, "slider_effect", value = cohen.ES(test = "t", 
                                                                                           size = "small")$effect.size,min = 0, max = 1, step = 0.05)}
    if(input$radio_cohen==2) {updateSliderInput(session, "slider_effect", value = cohen.ES(test = "t", 
                                                                                           size = "medium")$effect.size,min = 0, max = 1, step = 0.05)}
    if(input$radio_cohen==3) {updateSliderInput(session, "slider_effect", value = cohen.ES(test = "t", 
                                                                                           size = "large")$effect.size,min = 0, max = 1, step = 0.05)}
    if(input$select_test == 1) {
      input.n <- input$slider_n; input.d <- input$slider_effect; 
      input.p_value <- input$slider_p_value;input.power <- input$slider_power; 
      input.type <- ifelse(input$select_type==1,{"paired"},{"two.sample"})
      input.alternative <- ifelse(input$select_alternative==1, {"two.sided"}, 
                                  ifelse(input$select_alternative==2,{"greater"},{"less"}))
      
      if(input$radio == 1){
        shinyjs::disable('slider_power'); shinyjs::enable('slider_p_value'); 
        shinyjs::enable('slider_effect'); shinyjs::enable('slider_n');
        text_rezult <- "мощность"
        rez_test <- pwr.t.test(n = input.n, d = input.d, sig.level = input.p_value, power = NULL,
                               type = input.type, alternative = input.alternative)
        text_rezult <- paste(text_rezult,round(rez_test$power,3))
      }
      if(input$radio == 2){
        shinyjs::enable('slider_power'); shinyjs::disable('slider_p_value'); 
        shinyjs::enable('slider_effect'); shinyjs::enable('slider_n');
        text_rezult <- "достоверность"
        rez_test <- pwr.t.test(n = input.n, d = input.d, sig.level = NULL, power = input.power,
                               type = input.type, alternative = input.alternative)
        text_rezult <- paste(text_rezult,round(rez_test$sig.level,3))
      }
      if(input$radio == 3){
        shinyjs::enable('slider_power'); shinyjs::enable('slider_p_value'); 
        shinyjs::disable('slider_effect'); shinyjs::enable('slider_n');
        text_rezult <- "величина эффекта"
        rez_test <- pwr.t.test(n = input.n, d = NULL, sig.level = input.p_value, power = input.power,
                               type = input.type, alternative = input.alternative)
        text_rezult <- paste(text_rezult,round(rez_test$d,3))
      }
      if(input$radio == 4){
        shinyjs::enable('slider_power'); shinyjs::enable('slider_p_value'); 
        shinyjs::enable('slider_effect'); shinyjs::disable('slider_n');
        text_rezult <- "количество необходимых исследований"
        rez_test <- pwr.t.test(n = NULL, d = input.d, sig.level = input.p_value, power = input.power,
                               type = input.type, alternative = input.alternative)
        text_rezult <- paste(text_rezult,as.integer(round(rez_test$n,0)))
      }
    }
    if(input$select_test == 2) {text_rezult <- "тест Хи-квадрат в разработке"}
    if(input$select_test == 3) {text_rezult <- "тест корреляции Пирсона в разработке"}
    output$output_text <- renderText({text_rezult})
  })
})
