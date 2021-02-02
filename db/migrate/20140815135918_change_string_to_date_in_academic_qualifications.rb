class ChangeStringToDateInAcademicQualifications < ActiveRecord::Migration
  def change
    rename_column :academic_qualifications, :start_date, :start_date_string
    add_column :academic_qualifications, :start_date, :date
    AcademicQualification.reset_column_information
    AcademicQualification.find_each { |c| c.update_attribute(:start_date, c.start_date_string)}
    remove_column :academic_qualifications, :start_date_string
    
    rename_column :academic_qualifications, :end_date, :end_date_string
    add_column :academic_qualifications, :end_date, :date
    AcademicQualification.reset_column_information
    AcademicQualification.find_each { |a| a.update_attribute(:end_date, a.end_date_string)}
    remove_column :academic_qualifications, :end_date_string
  end
end
