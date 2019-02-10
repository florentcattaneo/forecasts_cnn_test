CREATE TEMP TABLE stores
AS
SELECT but_idr_business_unit,
       but_name_business_unit
FROM cds.d_business_unit
WHERE cnt_idr_country = 66
AND   but_num_typ_but = 7
AND   but_name_business_unit IN ('AIX LES MILLES','SAINT BRIEUC','CAMPUS')
GROUP BY but_idr_business_unit,
         but_name_business_unit;

DROP TABLE IF EXISTS tra;
CREATE TEMP TABLE tra
AS
SELECT DATE(tdt_date_to_ordered),
       sum(f_qty_item),
       sku.sku_idr_sku,
       but_name_business_unit,
       mdl_num_model_r3
FROM cds.f_transaction_detail tra
  INNER JOIN stores ON stores.but_idr_business_unit = tra.but_idr_business_unit
  INNER JOIN cds.d_sku sku ON tra.sku_idr_sku = sku.sku_idr_sku
WHERE tdt_date_to_ordered > CURRENT_DATE-INTERVAL '1 month'
AND   f_to_tax_in > 0
AND   mdl_num_model_r3 IN (8359376,8350582)
GROUP BY tdt_date_to_ordered,
         f_qty_item,
         sku.sku_idr_sku,
         but_name_business_unit,
         mdl_num_model_r3;

SELECT TOP 1000 *
FROM tra;

