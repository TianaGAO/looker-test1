view: sign_ins_and_email_updates {
  derived_table: {
    sql: SELECT
        user.id  AS `user.id`,
        user.first_name  AS `user.first_name`,
        user.last_name  AS `user.last_name`,
        COUNT(*) AS `analytics_data_user_adoption_sign_in.count`,
        adeuu.opens AS `email_update_opens`
      FROM pbdata.analytics_data_user_adoption_sign_in  AS analytics_data_user_adoption_sign_in
      LEFT JOIN pbdata.user  AS user ON analytics_data_user_adoption_sign_in.user_id = user.id
      JOIN analytics_data_email_update_users AS adeuu ON analytics_data_user_adoption_sign_in.user_id = adeuu.user_id

      WHERE (analytics_data_user_adoption_sign_in.company_id  = 275) AND ((((analytics_data_user_adoption_sign_in.date ) >= (CONVERT_TZ(TIMESTAMP('2017-10-01'),'America/New_York','UTC')) AND (analytics_data_user_adoption_sign_in.date ) < (CONVERT_TZ(TIMESTAMP('2018-01-01'),'America/New_York','UTC')))))
      GROUP BY 1,2,3
      ORDER BY user.first_name
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.`user.id` ;;
  }

  dimension: user_first_name {
    type: string
    sql: ${TABLE}.`user.first_name` ;;
  }

  dimension: user_last_name {
    type: string
    sql: ${TABLE}.`user.last_name` ;;
  }

  dimension: analytics_data_user_adoption_sign_in_count {
    type: string
    sql: ${TABLE}.`analytics_data_user_adoption_sign_in.count` ;;
  }

  dimension: email_update_opens {
    type: string
    sql: ${TABLE}.email_update_opens ;;
  }

  set: detail {
    fields: [user_id, user_first_name, user_last_name, analytics_data_user_adoption_sign_in_count, email_update_opens]
  }
}
