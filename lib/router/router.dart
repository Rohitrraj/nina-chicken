enum MyRoute {
  home("/home"),
  catalog("/catalog"),
  about("/about"),
  contactUs("/contact_us"),
  login("/login"),
  detail("/detail"),
  adminDashboard("/admin/dashboard"),
  adminOrders("/admin/orders"),
  adminAnalytics("/admin/analytics"),
  adminCatalog("/admin/catalog"),
  historyPage("/admin/history");

  const MyRoute(this.path);
  final String path;
}
