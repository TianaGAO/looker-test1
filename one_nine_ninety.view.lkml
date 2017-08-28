view: one_nine_ninety {
  derived_table: {
    sql:

    select
      user.id as user_id,
      user.company_id as companyid,
      NOT isnull(ninety_percent.user_id) as is_in_ninety_percent,
      NOT isnull(nine_percent.user_id) as is_in_nine_percent,
      NOT isnull(one_percent.user_id) as is_in_one_percent


      from user



      left outer join (
        select distinct user_id
        from analytics_data_user_adoption_sign_in
        where {% condition company_id %} company_id {% endcondition %} and {% condition date_range %} `date` {% endcondition %}
        and signed_in = 1
        union
        select distinct user_id
        from analytics_data_email_update_users
        where {% condition company_id %} company_id {% endcondition %} and {% condition date_range %} `date` {% endcondition %}
        and opens > 0
        union
        select distinct user_id
        from analytics_data_content_users
        where {% condition company_id %} company_id {% endcondition %} and {% condition date_range %} `date` {% endcondition %}
        and (
          impressions_web_app > 0 or
          impressions_mobile_ios > 0 or
          impressions_mobile_android > 0 or
          impressions_extension_ch > 0 or
          impressions_extension_ff > 0 or
          opens_web_app > 0 or
          opens_mobile_ios > 0 or
          opens_mobile_android > 0 or
          opens_extension_ch > 0 or
          opens_extension_ff > 0 or
          reads_web_app > 0 or
          reads_mobile_ios > 0 or
          reads_mobile_android > 0 or
          reads_extension_ch > 0 or
          reads_extension_ff > 0
        )

      ) as ninety_percent on ninety_percent.user_id = user.id

      left outer join (
        select distinct user_id
        from analytics_data_post_user
        where {% condition company_id %} company_id {% endcondition %} and {% condition date_range %} `date` {% endcondition %}
        and (twitter_share > 0 or facebook_share > 0 or linkedin_share > 0)

      ) as nine_percent on nine_percent.user_id = user.id

      left outer join (
        select distinct created_by_id as user_id
        from post
        where {% condition company_id %} company_id {% endcondition %} and {% condition date_range %} `created` {% endcondition %}
        union
        select distinct user_id as user_id
        from suggest_post
        where {% condition company_id %} company_id {% endcondition %} and {% condition date_range %} `created` {% endcondition %}
      ) as one_percent on one_percent.user_id = user.id

      where {% condition company_id %} company_id {% endcondition %}
      group by user.id

    ;;
  }

  dimension: user_id {
  label: "user id"
  type: number
  sql: ${TABLE}.user_id ;;
}
  dimension: is_ninety {
    type: number
    sql: ${TABLE}.is_in_ninety_percent = 1 AND ${TABLE}.is_in_nine_percent = 0 AND ${TABLE}.is_in_one_percent = 0  ;;
  }

  dimension: is_nine {
    type: number
    sql: ${TABLE}.is_in_nine_percent = 1 AND ${TABLE}.is_in_one_percent = 0  ;;
  }

  dimension: is_one {
    type: number
    sql: ${TABLE}.is_in_one_percent = 1  ;;
  }
  dimension: companyid {
    label: "company id"
    type: number
    sql: ${TABLE}.companyid ;;
  }

  measure: ninety {
    type: number
    sql: SUM(CASE WHEN ${is_ninety} THEN 1 ELSE 0 END) ;;
  }

  measure: nine {
    type: number
    sql: SUM(CASE WHEN ${is_nine} THEN 1 ELSE 0 END) ;;
  }

  measure: one {
    type: number
    sql: SUM(CASE WHEN ${is_one} THEN 1 ELSE 0 END) ;;
  }

  filter: company_id {
    label: "company"
    type:number
  }

  filter: date_range {
    label: "FILTER date"
    type: date
  }


}
