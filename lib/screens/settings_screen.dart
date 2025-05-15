import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../bloc/language/language_bloc.dart';
import '../bloc/language/language_event.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          // Секция внешнего вида
          _buildSection(
            context,
            'Внешний вид',
            [
              // Переключатель темы
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Тёмная тема'),
                trailing: Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (bool value) {
                    context.read<ThemeBloc>().add(
                          ToggleTheme(),
                        );
                  },
                ),
              ),
            ],
          ),
          const Divider(),
          // Секция языка
          _buildSection(
            context,
            'Язык',
            [
              // Выбор языка
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Язык приложения'),
                trailing: DropdownButton<String>(
                  value: 'ru',
                  items: const [
                    DropdownMenuItem(
                      value: 'ru',
                      child: Text('Русский'),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      context.read<LanguageBloc>().add(
                            ChangeLanguage(value),
                          );
                    }
                  },
                ),
              ),
            ],
          ),
          const Divider(),
          // Секция уведомлений
          _buildSection(
            context,
            'Уведомления',
            [
              // Уведомления о новых книгах
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: const Text('Новые книги'),
                subtitle: const Text('Уведомлять о появлении новых книг'),
                value: true,
                onChanged: (bool value) {
                  // TODO: Реализовать управление уведомлениями
                },
              ),
              // Уведомления об обновлениях
              SwitchListTile(
                secondary: const Icon(Icons.system_update),
                title: const Text('Обновления'),
                subtitle: const Text('Уведомлять об обновлениях приложения'),
                value: true,
                onChanged: (bool value) {
                  // TODO: Реализовать управление уведомлениями
                },
              ),
            ],
          ),
          const Divider(),
          // Секция данных
          _buildSection(
            context,
            'Данные',
            [
              // Кэширование
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Очистить кэш'),
                subtitle: const Text('Освободить место на устройстве'),
                onTap: () {
                  // TODO: Реализовать очистку кэша
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Кэш очищен'),
                    ),
                  );
                },
              ),
              // Синхронизация
              SwitchListTile(
                secondary: const Icon(Icons.sync),
                title: const Text('Автоматическая синхронизация'),
                subtitle: const Text('Синхронизировать данные в фоновом режиме'),
                value: true,
                onChanged: (bool value) {
                  // TODO: Реализовать управление синхронизацией
                },
              ),
            ],
          ),
          const Divider(),
          // Секция о приложении
          _buildSection(
            context,
            'О приложении',
            [
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Версия'),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Лицензии'),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Readify',
                    applicationVersion: '1.0.0',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
} 