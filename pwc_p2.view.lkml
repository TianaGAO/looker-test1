view: pwc_p2 {
  derived_table: {
    sql:
      SELECT p.title as post_title,
            p.content as content,
            p.created as created,
            inter.interactions

      FROM post AS p
      INNER JOIN (
            SELECT post_id, date, company_id, sum(facebook_clickthrough+ facebook_comment+ facebook_impression+ facebook_like+ facebook_reshare+ facebook_share+ linkedin_clickthrough+ linkedin_comment+ linkedin_impression+ linkedin_like+ linkedin_share + twitter_clickthrough+ twitter_favorite+ twitter_impression+ twitter_reply+ twitter_retweet+ twitter_share) as interactions
            FROM pbdata.analytics_data_posts

            WHERE
            {% condition company_id %} company_id {% endcondition %} AND
            {% condition date_range %} `date` {% endcondition %}
            GROUP BY post_id
                 ) AS inter ON inter.post_id = p.id
      WHERE
      {% condition company_id %} p.company_id {% endcondition %} AND
      {% condition date_range %} `created` {% endcondition %}

 ;;
  }


  # # Define your dimensions and measures here, like this:
  dimension: post_title {
    type: string
    sql: ${TABLE}.post_title ;;
  }
  dimension: content {
    type: string
    description: "the content of post"
    sql: ${TABLE}.content ;;
  }
  dimension: created_date {
    type: date_time
    sql: ${TABLE}.created;;
  }
  dimension: interactions {
    type: number
    description: "total interactions from three socia media"
    sql: ${TABLE}.interactions ;;
  }
    filter: company_id {
      label: "FILTER company_id"
      type: number
    }
    filter: date_range {
      label: "FILTER date_range"
      type: date
    }
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: pwc_p2 {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
