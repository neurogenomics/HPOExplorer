hpo_dict <- function(type=c("AgeOfDeath",
                            "onset",
                            "severity")){
  type <- tolower(type)[1]
  if(type=="ageofdeath"){
    dict <- c('Miscarriage'=1,
              'Stillbirth'=1,
              'Prenatal death'=1,
              'Neonatal death'=2,
              'Death in infancy'=3,
              'Death in childhood'=4,
              'Death in adolescence'=5,
              'Death in early adulthood'=6,
              'Death in middle age'=7,
              'Death in late adulthood'=8,
              'Death in adulthood'=7
    )

  } else if(type=="onset"){
    dict <- c('Fetal onset'=1,
              'Antenatal onset'=2,
              'Congenital onset'=3,
              'Neonatal onset'=4,
              'Infantile onset'=5,
              'Childhood onset'=6,
              'Juvenile onset'=7,
              'Young adult onset'=8,
              'Adult onset'=9,
              'Middle age onset'=10,
              'Late onset'=11)
  } else if(type=="severity"){
    dict <- c("Mild"=4,
              "Borderline"=3,
              "Severe"=2,
              "Profound"=1)
  }
 return(dict)
}
