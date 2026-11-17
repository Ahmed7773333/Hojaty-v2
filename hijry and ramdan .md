https://ramadan.munafio.com/api/check
Accept-Language: [en / ar]
{
  "status": "success",
  "message": "No, it is not Ramadan.",
  "data": {
    "isRamadan": false,
    "hijriDate": {
      "date": "12-03-1448",
      "format": "DD-MM-YYYY",
      "day": {
        "title": "Al Thalaata",
        "number": 12
      },
      "month": {
        "number": 3,
        "title": "Rabīʿ al-awwal"
      },
      "year": "1448"
    },
    "nextRamadan": {
      "date": "08-02-2027",
      "timeLeft": "5mo 17d left"
    }
  }
}
using this endpoint we will make a model for the response and a new hive object to store the hijri date and next ramadan date in the userbox with keys hijriDate and nextRamadan and we will use the hijr date we have to make the hijri callendar looks right and we will call this endpoint every time the app starts if there is no internet connection we will use the stored hijri date and next ramadan date and if there is internet connection we will call this endpoint and update the stored hijri date and next ramadan date and with that we will be finished with the two tabs of three in the occasions screen except the occasions tab itself i will pass the needed files and call the endpoint twice once with ar and another with en to store them both and show the right content depending on the use language