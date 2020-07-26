class AjaxController < ApplicationController
  before_filter :login_required
  respond_to :html,:json # :js, :xml
  layout false

  def questions
    job_id = nil
    template_id = nil

    puts params

    if params[:job_id] && params[:job_id] != ''
      job_id = params[:job_id].to_i
    end
    if params[:template_id] && params[:template_id] != ''
      template_id = params[:template_id].to_i
    end

    puts "job_id = #{job_id}, template_id = #{template_id}"

    @questions = Question.where(:job_id => job_id,:template_id => template_id).order(position: :asc)

    respond_to do |format|
      format.html
      format.json { render :json => @questions.to_json(except:[:created_at,:updated_at]) }
    end
  end

  def move_question
    id = params[:id]
    direction = params[:direction]

    question = Question.where(:id => id).first

    ajax_response = Hash.new
    ajax_response[:id] = id

    if question
      position_before_move = question.position
      if direction == 'up'
        question.move Question::DIRECTION_UP
      elsif direction == 'down'
        question.move Question::DIRECTION_DOWN
      end

      ajax_response[:success] = true
      ajax_response[:position] = question.position
      ajax_response[:previous_position] = position_before_move
    else
      ajax_response[:success] = false
    end

    render :json => ActiveSupport::JSON.encode(ajax_response)
  end

  def save_questions
    questions = params[:questions]
    questions.each do |q|
      question = Question.where(:id => q[1][:id].to_i).first
      if question
        question.position = q[1][:position]
        question.content = q[1][:content]
        question.question_type = q[1][:question_type]
        question.save!

        if question.question_type == Question::TYPE_OPEN_ENDED
          question.choices.each do |c|
            c.destroy
          end
        elsif question.question_type == Question::TYPE_SINGLE_OPTION || question.question_type == Question::TYPE_MULTIPLE_OPTION
          choices = q[1][:choices]
          choices.each do |c|
            choice = Choice.where(:id => c[1][:id].to_i).first
            if choice
              choice.content=c[1][:content]
              choice.save!
            end
          end
        end
      end
    end

    ajax_response = Hash.new
    ajax_response[:success] = true
    render :json => ActiveSupport::JSON.encode(ajax_response)
  end

  def new_choice
    question_id = params[:question_id]
    @choice = Choice.new
    @choice.question_id=question_id
    @choice.content='choice'
    @choice.save!

    @choice.content=''
  end

  def delete_choice
    id = params[:id]
    choice = Choice.where(:id => id).first

    ajax_response = Hash.new
    ajax_response[:id] = id

    if choice
      choice.destroy
      ajax_response[:success] = true
    else
      ajax_response[:success] = false
    end

    render :json => ActiveSupport::JSON.encode(ajax_response)
  end

  def new_question
    job_id = params[:job_id]
    template_id = params[:template_id]
    @question = Question.new
    @question.content = 'Content'
    @question.job_id = job_id
    @question.template_id=template_id
    @question.save!

    @question.content = ''
  end

  def delete_question
    id = params[:id]
    question = Question.where(:id => id).first

    ajax_response = Hash.new
    ajax_response[:id] = id

    if question
      question.destroy
      ajax_response[:success] = true
    else
      ajax_response[:success] = false
    end

    render :json => ActiveSupport::JSON.encode(ajax_response)
  end

  def job_fields
    job_id = params[:id]

    @fields = JobField.where(:job_id => job_id).order(position: :asc)

    respond_to do |format|
      format.html
      format.json { render :json => @fields.to_json(except:[:created_at,:updated_at]) }
    end
  end

  def delete_job_field
    id = params[:id]
    job_field = JobField.where(:id => id).first

    ajax_response = Hash.new
    ajax_response[:id] = id

    if job_field
      job_field.destroy
      ajax_response[:success] = true
    else
      ajax_response[:success] = false
    end

    render :json => ActiveSupport::JSON.encode(ajax_response)
  end

  def move_job_field
    id = params[:id]
    direction = params[:direction]

    job_field = JobField.where(:id => id).first

    ajax_response = Hash.new
    ajax_response[:id] = id

    if job_field
      position_before_move = job_field.position
      if direction == 'up'
        job_field.move JobField::DIRECTION_UP
      elsif direction == 'down'
        job_field.move JobField::DIRECTION_DOWN
      end

      ajax_response[:success] = true
      ajax_response[:position] = job_field.position
      ajax_response[:previous_position] = position_before_move
    else
      ajax_response[:success] = false
    end

    render :json => ActiveSupport::JSON.encode(ajax_response)
  end

  def new_job_field
    job_id = params[:id]
    @field = JobField.new
    @field.title = 'Title'
    @field.content = 'Content'
    @field.job_id = job_id
    @field.save!

    @field.title = ''
    @field.content = ''
  end

  def save_fields
    job_fields = params[:fields]

    job_fields.each do |f|
      job_field = JobField.where(:id => f[1][:id].to_i).first
      if job_field
        job_field.title = f[1][:title]
        job_field.content = f[1][:content]
        job_field.save!
      end
    end

    ajax_response = Hash.new
    ajax_response[:success] = true
    render :json => ActiveSupport::JSON.encode(ajax_response)
  end

end
