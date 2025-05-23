import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:milkride/core/common/app_text.dart';
import 'package:milkride/core/common/no_order_found_card.dart';
import 'package:milkride/core/common/product_card_loader.dart';
import 'package:milkride/core/constant/app_strings.dart';
import 'package:milkride/feature/order/presentation/cubit/order_cubit.dart';
import 'package:milkride/feature/order/presentation/cubit/order_state.dart';
import 'package:milkride/feature/order/presentation/screen/widgets/order_product_card.dart';
import 'package:milkride/feature/order/presentation/screen/widgets/order_total_section.dart';

class DeliveredSection extends StatelessWidget {
  const DeliveredSection({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return ProductCardLoader(productHeight: 60.h, productWidth: 0.9.sw, padding: 5, count:5, productRadius: 5);
        } else if (state is OrderLoaded) {
          final res = state.orderResponse;
          final deliveredList = state.orderResponse.data?.delivered ?? [];
          if (deliveredList.isEmpty) {
            return CommonEmptyCard(messege: AppStrings.noOrderFound, icon: Icons.category);
          } else {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              children: [
                ListView.builder(
                  itemCount: deliveredList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return OrderProductCard(
                      product: deliveredList[index],
                      onDelete: () {},
                    );
                  },
                ).paddingOnly(bottom: 10.h),
                AppText(
                  data: AppStrings.orderDetail,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ).paddingOnly(left: 10.w),
                OrderDetailSection(total: res.deliveredGrandTotal.toString())
                    .paddingSymmetric(horizontal: 5.w, vertical: 10.h),
              ],
            );
          }
        }
        return Container();
      },
    );
  }
}
