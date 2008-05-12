require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

module Arel
  describe Insertion do
    before do
      @relation = Table.new(:users)
    end
  
    describe '#to_sql' do
      it 'manufactures sql inserting data when given multiple rows' do
        pending 'it should insert multiple rows'
        @insertion = Insertion.new(@relation, [@relation[:name] => "nick", @relation[:name] => "bryan"])
      
        @insertion.to_sql.should be_like("
          INSERT
          INTO `users`
          (`users`.`name`) VALUES ('nick'), ('bryan')
        ")
      end
      
      it 'manufactures sql inserting data when given multiple values' do
        @insertion = Insertion.new(@relation, @relation[:id] => "1", @relation[:name] => "nick")
      
        @insertion.to_sql.should be_like("
          INSERT
          INTO `users`
          (`users`.`name`, `users`.`id`) VALUES ('nick', 1)
        ")
      end
      
      describe 'when given values whose types correspond to the types of the attributes' do
        before do
          @insertion = Insertion.new(@relation, @relation[:name] => "nick")
        end
        
        it 'manufactures sql inserting data' do
          @insertion.to_sql.should be_like("
            INSERT
            INTO `users`
            (`users`.`name`) VALUES ('nick')
          ")
        end
      end
      
      describe 'when given values whose types differ from from the types of the attributes' do
        before do
          @insertion = Insertion.new(@relation, @relation[:id] => '1-asdf')
        end
        
        it 'manufactures sql inserting data' do
          @insertion.to_sql.should be_like("
            INSERT
            INTO `users`
            (`users`.`id`) VALUES (1)
          ")
        end
      end
    end
    
    describe '#call' do
      before do
        @insertion = Insertion.new(@relation, @relation[:name] => "nick")
      end
      
      it 'executes an insert on the connection' do
        mock(connection = Object.new).insert(@insertion.to_sql)
        @insertion.call(connection)
      end
    end
  end
end