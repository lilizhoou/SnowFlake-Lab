''' start from small one ''' 
CREATE OR REPLACE TABLE customers 
AS 
SELECT
   $1 AS id,
   parse_json($2) AS info
FROM VALUES
   (
   12712555,
   '{"name": {"first":"John", "last":"Smith"},
     "contact": [
        {"business": {"phone":"303-555-1234", "email":"j.smith@company.com"}},
        {"personal": {"phone":"303-421-8322", "email":"jsmith332@gmail.com"}}
        ],
     }'
   ),
   (
   98127771,
   '{"name": {"first":"Jane", "last":"Doe"},
     "contact": [
        {"business": {"phone":"303-638-4887", "email":"jg_doe@company2.com"}},
        {"personal": {"phone":"303-678-6789", "email":"happyjane@gmail.com"}}
        ],
     }'
   );


-- Fetch ID, first_name, last_name, buiness_email, business_phone, personal_email, personal_phone 
SELECT
   ID,
   info:name.first::VARCHAR AS first_name,
   info:name.last::VARCHAR AS last_name,
   business.value:email::VARCHAR as business_email,
   business.value:phone::VARCHAR as business_phone,
   personal.value:email::VARCHAR as personal_email,
   personal.value:phone::VARCHAR as personal_phone
FROM
   customers,
LATERAL FLATTEN(input=>info:contact[0]) business,
LATERAL FLATTEN(input=>info:contact[1]) personal;

SELECT
   ID,
   info:name.first::VARCHAR AS first_name,
   info:name.last::VARCHAR AS last_name,
   business.value:email::VARCHAR as business_email,
   business.value:phone::VARCHAR as business_phone,
   personal.value:email::VARCHAR as personal_email,
   personal.value:phone::VARCHAR as personal_phone
FROM
   customers,
LATERAL FLATTEN(input=>info:contact[0]) business,
LATERAL FLATTEN(input=>info:contact[1]) personal;


================================================================================================
''' Go Bigger '''

CREATE OR REPLACE TABLE weather_data 
AS 
SELECT
   parse_json($1) AS w
FROM VALUES
('{
  "data": {
    "observations": [
      {
        "air": {
          "dew-point": 8.2,
          "dew-point-quality-code": "1",
          "temp": 29.8,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10161,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T02:00:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 80,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 41
        }
      },
      {
        "air": {
          "dew-point": 8.2,
          "dew-point-quality-code": "1",
          "temp": 29.9,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10161,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T02:30:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 80,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 41
        }
      },
      {
        "air": {
          "dew-point": 6.4,
          "dew-point-quality-code": "1",
          "temp": 32.2,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10126,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T05:00:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 60,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 57
        }
      },
      {
        "air": {
          "dew-point": 6.4,
          "dew-point-quality-code": "1",
          "temp": 32.2,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10126,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T05:30:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 60,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 57
        }
      },
      {
        "air": {
          "dew-point": 5.1,
          "dew-point-quality-code": "1",
          "temp": 30.6,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10123,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T08:00:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 140,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 26
        }
      },
      {
        "air": {
          "dew-point": 5.1,
          "dew-point-quality-code": "1",
          "temp": 30.7,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10123,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T08:30:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 140,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 26
        }
      },
      {
        "air": {
          "dew-point": 3.5,
          "dew-point-quality-code": "1",
          "temp": 18.9,
          "temp-quality-code": "2"
        },
        "atmospheric": {
          "pressure": 10152,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T11:00:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 120,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 10
        }
      },
      {
        "air": {
          "dew-point": 3.5,
          "dew-point-quality-code": "1",
          "temp": 19,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10152,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T11:30:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 120,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 10
        }
      },
      {
        "air": {
          "dew-point": 5.5,
          "dew-point-quality-code": "1",
          "temp": 17.9,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10165,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T14:00:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 150,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 10
        }
      },
      {
        "air": {
          "dew-point": 5.5,
          "dew-point-quality-code": "1",
          "temp": 18,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10165,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T14:30:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 150,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 10
        }
      },
      {
        "air": {
          "dew-point": 5,
          "dew-point-quality-code": "1",
          "temp": 13.3,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10163,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T17:00:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 140,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 5
        }
      },
      {
        "air": {
          "dew-point": 5,
          "dew-point-quality-code": "1",
          "temp": 13.4,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10163,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T17:30:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 140,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 5
        }
      },
      {
        "air": {
          "dew-point": 7.8,
          "dew-point-quality-code": "1",
          "temp": 13.8,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10177,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T20:00:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 160,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 15
        }
      },
      {
        "air": {
          "dew-point": 7.8,
          "dew-point-quality-code": "1",
          "temp": 13.9,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10177,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T20:30:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 160,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 15
        }
      },
      {
        "air": {
          "dew-point": 9.4,
          "dew-point-quality-code": "1",
          "temp": 22.2,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10190,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T23:00:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 130,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 21
        }
      },
      {
        "air": {
          "dew-point": 9.4,
          "dew-point-quality-code": "1",
          "temp": 22.2,
          "temp-quality-code": "1"
        },
        "atmospheric": {
          "pressure": 10190,
          "pressure-quality-code": "1"
        },
        "dt": "2019-07-30T23:30:00",
        "sky": {
          "ceiling": 99999,
          "ceiling-quality-code": "9"
        },
        "visibility": {
          "distance": 999999,
          "distance-quality-code": "9"
        },
        "wind": {
          "direction-angle": 130,
          "direction-quality-code": "1",
          "speed-quality-code": "1",
          "speed-rate": 21
        }
      }
    ]
  },
  "station": {
    "USAF": "942340",
    "WBAN": 99999,
    "coord": {
      "lat": -16.25,
      "lon": 133.367
    },
    "country": "AS",
    "elev": 211,
    "id": "94234099999",
    "name": "DALY WATERS AWS"
  }
}');

select * from weather_data;

 -- 
SELECT 
        wd.w:station.USAF::VARCHAR AS USAF, 
        wd.w:station.country::VARCHAR AS country,
        wd.w:station.elev::VARCHAR AS elev,
        wd.w:station.id::VARCHAR AS id,
        wd.w:station.name::VARCHAR AS name
 FROM 
    weather_data wd;

-- Select average, max, and min air temperature using LATERAL FLATTEN 

select 
avg(ob.value:air.temp)::number(38,1) as avg_temp_c,
min(ob.value:air.temp)::number(38,1) as min_temp_c,
max(ob.value:air.temp)::number(38,1) as max_temp_c,
from weather_data w,
lateral flatten(input=> w:data.observations) as ob







