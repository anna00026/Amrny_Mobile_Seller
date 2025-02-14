import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/auth_services/change_pass_service.dart';
import 'package:amrny_seller/services/auth_services/delete_account_service.dart';
import 'package:amrny_seller/services/auth_services/email_verify_service.dart';
import 'package:amrny_seller/services/auth_services/login_service.dart';
import 'package:amrny_seller/services/auth_services/logout_service.dart';
import 'package:amrny_seller/services/auth_services/reset_password_service.dart';
import 'package:amrny_seller/services/auth_services/signup_service.dart';
import 'package:amrny_seller/services/cat_subcat_dropdown_service_for_edit_service.dart';
import 'package:amrny_seller/services/category_subcat_dropdown_service.dart';
import 'package:amrny_seller/services/chart_service.dart';
import 'package:amrny_seller/services/country_states_service.dart';
import 'package:amrny_seller/services/dashboard_service.dart';
import 'package:amrny_seller/services/day_schedule_service/day_service.dart';
import 'package:amrny_seller/services/day_schedule_service/schedule_service.dart';
import 'package:amrny_seller/services/deactivate_account_service.dart';
import 'package:amrny_seller/services/dropdowns_services/area_dropdown_service.dart';
import 'package:amrny_seller/services/dropdowns_services/country_dropdown_service.dart';
import 'package:amrny_seller/services/dropdowns_services/state_dropdown_services.dart';
import 'package:amrny_seller/services/employees/employees_service.dart';
import 'package:amrny_seller/services/jobs/all_jobs_service.dart';
import 'package:amrny_seller/services/jobs/job_conversation_service.dart';
import 'package:amrny_seller/services/jobs/job_details_service.dart';
import 'package:amrny_seller/services/jobs/job_list_service.dart';
import 'package:amrny_seller/services/jobs/new_jobs_service.dart';
import 'package:amrny_seller/services/live_chat/chat_list_service.dart';
import 'package:amrny_seller/services/live_chat/chat_message_service.dart';
import 'package:amrny_seller/services/my_services/attribute_service.dart';
import 'package:amrny_seller/services/my_services/create_services_service.dart';
import 'package:amrny_seller/services/my_services/edit_attribute_service.dart';
import 'package:amrny_seller/services/my_services/my_services_service.dart';
import 'package:amrny_seller/services/order_details_service.dart';
import 'package:amrny_seller/services/orders_service.dart';
import 'package:amrny_seller/services/payments_service/gateway_services/bank_transfer_service.dart';
import 'package:amrny_seller/services/payments_service/payment_details_service.dart';
import 'package:amrny_seller/services/payments_service/payment_gateway_list_service.dart';
import 'package:amrny_seller/services/payments_service/payment_service.dart';
import 'package:amrny_seller/services/payout_details_service.dart';
import 'package:amrny_seller/services/payout_history_service.dart';
import 'package:amrny_seller/services/permissions_service.dart';
import 'package:amrny_seller/services/profile_edit_service.dart';
import 'package:amrny_seller/services/profile_service.dart';
import 'package:amrny_seller/services/profile_verify_service.dart';
import 'package:amrny_seller/services/push_notification_service.dart';
import 'package:amrny_seller/services/recent_orders_service.dart';
import 'package:amrny_seller/services/report_services/report_message_service.dart';
import 'package:amrny_seller/services/report_services/report_service.dart';
import 'package:amrny_seller/services/rtl_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/services/ticket_services/create_ticket_service.dart';
import 'package:amrny_seller/services/ticket_services/support_messages_service.dart';
import 'package:amrny_seller/services/ticket_services/support_ticket_service.dart';
import 'package:amrny_seller/services/wallet_service.dart';
import 'package:amrny_seller/services/withdraw_service.dart';

class NotifierProviders {
  static List<SingleChildWidget> getNotifierProviders() {
    return [
      ChangeNotifierProvider(create: (_) => LoginService()),
      ChangeNotifierProvider(create: (_) => ProfileService()),
      ChangeNotifierProvider(create: (_) => ChangePassService()),
      ChangeNotifierProvider(create: (_) => EmailVerifyService()),
      ChangeNotifierProvider(create: (_) => LogoutService()),
      ChangeNotifierProvider(create: (_) => ResetPasswordService()),
      ChangeNotifierProvider(create: (_) => SignupService()),
      ChangeNotifierProvider(create: (_) => LoginService()),
      ChangeNotifierProvider(create: (_) => CountryStatesService()),
      ChangeNotifierProvider(create: (_) => RtlService()),
      ChangeNotifierProvider(create: (_) => SupportTicketService()),
      ChangeNotifierProvider(create: (_) => WithdrawService()),
      ChangeNotifierProvider(create: (_) => OrdersService()),
      ChangeNotifierProvider(create: (_) => OrderDetailsService()),
      ChangeNotifierProvider(create: (_) => ProfileVerifyService()),
      ChangeNotifierProvider(create: (_) => ProfileEditService()),
      ChangeNotifierProvider(create: (_) => DeactivateAccountService()),
      ChangeNotifierProvider(create: (_) => DashboardService()),
      ChangeNotifierProvider(create: (_) => RecentOrdersService()),
      ChangeNotifierProvider(create: (_) => SupportMessagesService()),
      ChangeNotifierProvider(create: (_) => PayoutHistoryService()),
      ChangeNotifierProvider(create: (_) => PaymentGatewayListService()),
      ChangeNotifierProvider(create: (_) => PayoutDetailsService()),
      ChangeNotifierProvider(create: (_) => ChartService()),
      ChangeNotifierProvider(create: (_) => AppStringService()),
      ChangeNotifierProvider(create: (_) => ChatListService()),
      ChangeNotifierProvider(create: (_) => ChatMessagesService()),
      ChangeNotifierProvider(create: (_) => SubscriptionService()),
      ChangeNotifierProvider(create: (_) => JobListService()),
      ChangeNotifierProvider(create: (_) => NewJobsService()),
      ChangeNotifierProvider(create: (_) => JobConversationService()),
      ChangeNotifierProvider(create: (_) => JobDetailsService()),
      ChangeNotifierProvider(create: (_) => WalletService()),
      ChangeNotifierProvider(create: (_) => PaymentService()),
      ChangeNotifierProvider(create: (_) => PaymentDetailsService()),
      ChangeNotifierProvider(create: (_) => BankTransferService()),
      ChangeNotifierProvider(create: (_) => PushNotificationService()),
      ChangeNotifierProvider(create: (_) => ReportService()),
      ChangeNotifierProvider(create: (_) => ReportMessagesService()),
      ChangeNotifierProvider(create: (_) => MyServicesService()),
      ChangeNotifierProvider(create: (_) => CategorySubCatDropdownService()),
      ChangeNotifierProvider(create: (_) => AttributeService()),
      ChangeNotifierProvider(create: (_) => EditAttributeService()),
      ChangeNotifierProvider(create: (_) => CreateServicesService()),
      ChangeNotifierProvider(create: (_) => PermissionsService()),
      ChangeNotifierProvider(create: (_) => DayService()),
      ChangeNotifierProvider(create: (_) => ScheduleService()),
      ChangeNotifierProvider(create: (_) => CreateTicketService()),
      ChangeNotifierProvider(create: (_) => CountryDropdownService()),
      ChangeNotifierProvider(create: (_) => StateDropdownService()),
      ChangeNotifierProvider(create: (_) => AreaDropdownService()),
      ChangeNotifierProvider(create: (_) => AllJobsService()),
      ChangeNotifierProvider(create: (_) => DeleteAccountService()),
      ChangeNotifierProvider(
          create: (_) => CatSubcatDropdownServiceForEditService()),
      ChangeNotifierProvider(create: (_) => EmployeesService()),
    ];
  }
}
