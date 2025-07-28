import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/common_providers/availability_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {

  int _selectedStatus = 1;
  int _selectedDayIndex = 0;
  int _selectedTimeSlotIndex = -1;
  int _selectedRepeatOption = 0;

  List<Map<String, String>> _days = [
    {"day": "Sun", "date": "28"},
    {"day": "Mon", "date": "29"},
    {"day": "Tue", "date": "30"},
    {"day": "Wed", "date": "31"},
    {"day": "Thu", "date": "1"},
    {"day": "Fri", "date": "2"},
    {"day": "Sat", "date": "3"},
  ];

  List<String> _timeSlots = [
    'Morning\n8:00-12:00',
    'Afternoon\n12:00-5:00',
    'Evening\n5:00-8:00',
    'Night\n8:00-10:00'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        title: Center(
          child: const Text(
            'Availability Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Status',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusCard(
                  status: 1,
                  title: 'Available',
                  subtitle: 'for playdates',
                  icon: Icons.check_circle,
                  iconColor: const Color(0xFF36D399),
                  borderColor: const Color(0xFF36D399),
                ),
                _buildStatusCard(
                  status: 0,
                  title: 'Busy',
                  subtitle: 'not available',
                  icon: Icons.event_busy,
                  iconColor: AppColors.unavailableRed,
                  borderColor: const Color(0x14F87171),
                ),
                _buildStatusCard(
                  status: 2,
                  title: 'Maybe',
                  subtitle: 'available',
                  icon: Icons.help_outline,
                  iconColor: const Color(0xFFFFE082),
                  borderColor: const Color(0x14FFE082),
                ),
              ],
            ),
            const SizedBox(height: 30.0),

            // ⬇️ DAY SELECTOR
            const Text(
              'Choose Days Available',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16.0),
            _buildDaySelector(),

            const SizedBox(height: 30.0),

            // ⬇️ TIME SLOT SELECTOR
            const Text(
              'Available Time Slots',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16.0),
            _buildTimeSlotSelector(),

            const SizedBox(height: 30.0),
            const Text(
              'Repeat Schedule',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16.0),
            _buildRepeatScheduleOptions(),

            Center(
              child: ElevatedButton(onPressed: (){
                context.push('/availability_preview');
              },
                style: ElevatedButton.styleFrom(
                  shadowColor: Color(0x1A000000),
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                child:  const Text(
                  'Preview',
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ),
            ),

            const SizedBox(height: 30.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.primaryBlue, fontSize: 14.0),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final availabilityProvider = Provider.of<AvailabilityProvider>(context, listen: false);
                      List<int> datesToUpdate = [];

                      if (_days.isNotEmpty) {
                        datesToUpdate.add(21);
                      } else {
                        datesToUpdate = [1, 5, 10, 15, 20, 25];
                      }

                      availabilityProvider.setAvailabilityForDates(datesToUpdate, _selectedStatus);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Availability Saved!')),
                      );
                      context.push('/up_coming_events');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ⬇️ STATUS CARD
  Widget _buildStatusCard({
    required int status,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
  }) {
    bool isSelected = _selectedStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? borderColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? borderColor : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: borderColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: isSelected ? iconColor : AppColors.textColorPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w500,
                color: Color(0xCC1B1D2A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_days.length, (index) {
          bool isSelected = _selectedDayIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade100 : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _days[index]["day"]!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _days[index]["date"]!,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: isSelected ? Colors.blue : AppColors.textColorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
  Widget _buildTimeSlotSelector() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(_timeSlots.length, (index) {
          bool isSelected = _selectedTimeSlotIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTimeSlotIndex = index;
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Color(0x80D8ECFF) : Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: isSelected ? Color(0xFF5A8DEE) : Color(0x1A1B1D2A),
                ),
              ),
              child: Text(
                _timeSlots[index],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.buttonPrimary : AppColors.textColorPrimary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRepeatScheduleOptions() {
    final List<String> options = [
      'Just this once',
      'Repeat weekly',
      'Repeat monthly',
      'Custom schedule',
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Repeat Schedule',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12.0),
          ...List.generate(options.length, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedRepeatOption == index
                      ? AppColors.primaryBlue
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: RadioListTile<int>(
                title: Text(
                  options[index],
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.textColorPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                value: index,
                groupValue: _selectedRepeatOption,
                onChanged: (int? value) {
                  setState(() {
                    _selectedRepeatOption = value!;
                  });
                },
                activeColor: AppColors.primaryBlue,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
