import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/safeband_data.dart';
import '../common/call_dialog.dart';

class MessageWorkerView extends StatefulWidget {
  final String workerName;

  const MessageWorkerView({super.key, this.workerName = 'Suresh'});

  @override
  State<MessageWorkerView> createState() => _MessageWorkerViewState();
}

class _MessageWorkerViewState extends State<MessageWorkerView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'Supervisor',
      'text': 'Suresh, an automated hazard trigger was logged in Area B. Are you at your station?',
      'time': '10:24 AM',
      'isSupervisor': true,
    },
    {
      'sender': 'Suresh',
      'text': 'Yes supervisor, there was a minor pressure valve fluctuation. I am standing near reaction unit 4.',
      'time': '10:25 AM',
      'isSupervisor': false,
    },
    {
      'sender': 'Supervisor',
      'text': 'Evacuate immediately to Muster Point 2. Do not attempt manual valve inspection.',
      'time': '10:25 AM',
      'isSupervisor': true,
    },
    {
      'sender': 'Suresh',
      'text': 'Copy supervisor! Moving to muster point right now.',
      'time': '10:26 AM',
      'isSupervisor': false,
    },
  ];

  final List<String> _quickSafetyChips = [
    'Evacuate immediately!',
    'Please check your oxygen mask',
    'Confirm your status',
    'Help is on the way',
    'Remain at muster point',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'Supervisor',
        'text': text,
        'time': '10:27 AM',
        'isSupervisor': true,
      });
      if (textToSend == null) _controller.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate worker confirmation response after 1.5 seconds
    if (text.toLowerCase().contains('evacuate') || text.toLowerCase().contains('status')) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _messages.add({
              'sender': widget.workerName,
              'text': 'Acknowledged. Following supervisor safety directive.',
              'time': '10:28 AM',
              'isSupervisor': false,
            });
          });
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final worker = SafeBandData.getWorkerByName(widget.workerName);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: worker.statusColor.withValues(alpha: 0.15),
              child: Text(
                worker.initials,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: worker.statusColor),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        worker.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: worker.statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: worker.statusColor),
                        ),
                        child: Text(
                          worker.statusText,
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: worker.statusColor),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    worker.area,
                    style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_rounded, color: AppColors.safetyAccent),
            tooltip: 'Call Worker',
            onPressed: () {
              EmergencyCallDialog.show(
                context,
                contactName: worker.name,
                contactSubtitle: '${worker.area} (${worker.id})',
                phoneNumber: worker.phone,
                isWorker: true,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat message stream
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isSupervisor = msg['isSupervisor'] as bool;

                  return Align(
                    alignment: isSupervisor ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.78,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSupervisor ? AppColors.surface : AppColors.cardBackground,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(14),
                          topRight: const Radius.circular(14),
                          bottomLeft: isSupervisor ? const Radius.circular(14) : Radius.zero,
                          bottomRight: isSupervisor ? Radius.zero : const Radius.circular(14),
                        ),
                        border: Border.all(
                          color: isSupervisor ? AppColors.safetyAccent.withValues(alpha: 0.4) : AppColors.border,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isSupervisor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg['sender'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isSupervisor ? AppColors.safetyAccent : worker.statusColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                msg['time'] as String,
                                style: const TextStyle(fontSize: 9, color: AppColors.disabledText),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg['text'] as String,
                            style: const TextStyle(fontSize: 13, color: AppColors.primaryText, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Quick Safety Preset Chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: AppColors.surface,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickSafetyChips.map((chip) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        backgroundColor: AppColors.cardBackground,
                        side: const BorderSide(color: AppColors.border),
                        label: Text(
                          chip,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                        ),
                        onPressed: () => _sendMessage(chip),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(fontSize: 13, color: AppColors.primaryText),
                        decoration: const InputDecoration(
                          hintText: 'Type safety message or dispatch...',
                          hintStyle: TextStyle(fontSize: 12, color: AppColors.mutedText),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 11),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _sendMessage(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.safetyAccent,
                      ),
                      child: const Icon(Icons.send_rounded, size: 20, color: AppColors.background),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
