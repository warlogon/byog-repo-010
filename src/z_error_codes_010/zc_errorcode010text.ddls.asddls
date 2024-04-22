@EndUserText.label: 'Maintain Error Code 010 Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_ErrorCode010Text
  as projection on ZI_ErrorCode010Text
{
  @ObjectModel.text.element: [ 'LanguageName' ]
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Language', 
      element: 'Language'
    }
  } ]
  key Langu,
  key ErrorCode,
  Description,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _ErrorCode010 : redirected to parent ZC_ErrorCode010,
  _ErrorCode010All : redirected to ZC_ErrorCode010_S
  
}
