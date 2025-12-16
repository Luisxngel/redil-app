import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../services/backup_service.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool _isLoading = false;

  void _createBackup() async {
    setState(() => _isLoading = true);
    try {
      await getIt<BackupService>().createBackup();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copia de seguridad creada correctamente. (Revisa tus descargas/compartir)')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _restoreBackup() async {
    // 1. Alert Dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Restaurar Copia de Seguridad'),
        content: const Text(
          'Esta acción BORRARÁ TODOS los datos actuales y los reemplazará con el archivo seleccionado.\n\n¿Estás seguro de continuar?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Restaurar (Borrar Todo)'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 2. Execution
    setState(() => _isLoading = true);
    try {
      final success = await getIt<BackupService>().restoreBackup();
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos restaurados correctamente. Reinicia la app para ver cambios completos.')),
          );
          // Optional: Force app reload or nav back
          Navigator.pop(context); // Go back to Settings
        }
      } else {
        // Cancelled by user in picker
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Copia de Seguridad'),
      ),
      body: _isLoading 
        ? const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Procesando datos...'),
            ],
          ))
        : ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'Modo Offline', 
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Los datos se guardan exclusivamente en este dispositivo. '
                        'Crea copias de seguridad manualmente y guárdalas en Google Drive o envíalas por WhatsApp para evitar perder información si cambias de celular.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // EXPORT
              ListTile(
                title: const Text('Crear Copia de Seguridad'),
                subtitle: const Text('Exportar todos los datos a un archivo .json'),
                leading: const Icon(Icons.download_rounded, color: Colors.blue),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _createBackup,
                tileColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              
              const SizedBox(height: 16),
              
              // IMPORT
              ListTile(
                title: const Text('Restaurar Copia de Seguridad'),
                subtitle: const Text('Importar archivo .json (Borra datos actuales)'),
                leading: const Icon(Icons.restore_page_rounded, color: Colors.red),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _restoreBackup,
                tileColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ],
          ),
    );
  }
}
