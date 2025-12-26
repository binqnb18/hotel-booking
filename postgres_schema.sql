-- Postgres DDL for Hotel Booking System
-- Created: generated for project

-- Enum types
CREATE TYPE provider_type AS ENUM ('local','google','otp');
CREATE TYPE staff_role_type AS ENUM ('admin','hotel_owner','hotel_staff');
CREATE TYPE hotel_status_type AS ENUM ('pending','approved','rejected','suspended');
CREATE TYPE room_status_type AS ENUM ('available','maintenance','dirty','blocked');
CREATE TYPE payment_type AS ENUM ('pay_now','pay_at_hotel');
CREATE TYPE booking_status_type AS ENUM ('pending_payment','paid','checked_in','checked_out','cancelled','no_show','expired');
CREATE TYPE voucher_type AS ENUM ('percentage','fixed');
CREATE TYPE payment_method_type AS ENUM ('momo','vnpay','zalopay','card','bank_transfer','cash_at_hotel');
CREATE TYPE payment_status_type AS ENUM ('pending','success','failed','refunded','partial_refunded');
CREATE TYPE partner_payouts_status_type AS ENUM ('calculated','pending_approval','approved','paid','failed','cancelled');
CREATE TYPE review_status_type AS ENUM ('published','hidden','flagged');
CREATE TYPE hotel_contracts_status_type AS ENUM ('pending','approved','rejected','need_more_info');
CREATE TYPE user_type_enum AS ENUM ('guest','staff');
CREATE TYPE actor_type_enum AS ENUM ('guest','staff','system');
CREATE TYPE complaint_category_type AS ENUM ('refund','fake_review','payment_issue','security','other');
CREATE TYPE complaint_status_type AS ENUM ('open','in_review','resolved','rejected');
CREATE TYPE sender_type_enum AS ENUM ('guest','staff','system');

-- RBAC: roles and permissions tables
CREATE TABLE roles (
  role_id BIGSERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  description TEXT
);

CREATE TABLE permissions (
  permission_id BIGSERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  description TEXT
);

CREATE TABLE role_permissions (
  role_id BIGINT NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
  permission_id BIGINT NOT NULL REFERENCES permissions(permission_id) ON DELETE CASCADE,
  PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE staff_roles (
  staff_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
  PRIMARY KEY (staff_id, role_id)
);

-- Seed basic roles
INSERT INTO roles (name, description) VALUES
  ('admin', 'System administrator with full privileges'),
  ('hotel_owner', 'Hotel owner account'),
  ('hotel_staff', 'Hotel staff account');

-- Tables
CREATE TABLE guests (
  guest_id BIGSERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE,
  password_hash VARCHAR(255),
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20) UNIQUE NOT NULL,
  full_name VARCHAR(100),
  provider provider_type DEFAULT 'local',
  provider_id VARCHAR(255),
  avatar_url VARCHAR(500),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT chk_local_provider CHECK ((provider = 'local' AND password_hash IS NOT NULL) OR provider <> 'local')
);

CREATE TABLE staff (
  staff_id BIGSERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20) UNIQUE,
  full_name VARCHAR(100) NOT NULL,
  role staff_role_type NOT NULL,
  hotel_id BIGINT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE hotels (
  hotel_id BIGSERIAL PRIMARY KEY,
  owner_id BIGINT NOT NULL,
  name VARCHAR(150) NOT NULL,
  slug VARCHAR(160) UNIQUE NOT NULL,
  description TEXT,
  address VARCHAR(255) NOT NULL,
  city VARCHAR(50) NOT NULL,
  district VARCHAR(50),
  latitude NUMERIC(10,8),
  longitude NUMERIC(11,8),
  star_rating NUMERIC(2,1) DEFAULT 0.0,
  commission_rate NUMERIC(5,2) DEFAULT 15.00,
  checkin_time TIME DEFAULT '14:00:00',
  checkout_time TIME DEFAULT '12:00:00',
  status hotel_status_type DEFAULT 'pending',
  images JSONB DEFAULT '[]',
  amenities JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE room_types (
  room_type_id BIGSERIAL PRIMARY KEY,
  hotel_id BIGINT NOT NULL,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(120),
  description TEXT,
  size_m2 NUMERIC(5,2),
  max_adults INT DEFAULT 2,
  max_children INT DEFAULT 0,
  bed_config VARCHAR(100),
  view_type VARCHAR(50),
  images JSONB DEFAULT '[]',
  amenities JSONB DEFAULT '[]',
  default_price NUMERIC(12,2) NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE physical_rooms (
  physical_room_id BIGSERIAL PRIMARY KEY,
  hotel_id BIGINT NOT NULL,
  room_type_id BIGINT NOT NULL,
  room_number VARCHAR(20) NOT NULL,
  floor VARCHAR(10),
  status room_status_type DEFAULT 'available'
);

CREATE TABLE room_rates (
  rate_id BIGSERIAL PRIMARY KEY,
  room_type_id BIGINT NOT NULL,
  date DATE NOT NULL,
  price NUMERIC(12,2) NOT NULL,
  is_closed BOOLEAN DEFAULT FALSE
);

CREATE TABLE room_holds (
  hold_id BIGSERIAL PRIMARY KEY,
  session_id VARCHAR(100) NOT NULL,
  guest_id BIGINT,
  room_type_id BIGINT NOT NULL,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  num_rooms INT NOT NULL DEFAULT 1,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bookings (
  booking_id BIGSERIAL PRIMARY KEY,
  booking_code VARCHAR(12) UNIQUE NOT NULL,
  guest_id BIGINT NOT NULL,
  hotel_id BIGINT NOT NULL,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  num_nights INT NOT NULL,
  num_adults INT NOT NULL,
  num_children INT DEFAULT 0,
  subtotal NUMERIC(12,2) NOT NULL,
  discount_amount NUMERIC(12,2) DEFAULT 0,
  service_fee NUMERIC(12,2) DEFAULT 0,
  tax_amount NUMERIC(12,2) DEFAULT 0,
  total_payable NUMERIC(12,2) NOT NULL,
  commission_rate NUMERIC(5,2) DEFAULT 15.00,
  commission_amount NUMERIC(12,2) NOT NULL,
  hotel_payout NUMERIC(12,2) NOT NULL,
  payment_type payment_type DEFAULT 'pay_now',
  booking_status booking_status_type DEFAULT 'pending_payment',
  special_requests TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE booking_rooms (
  booking_room_id BIGSERIAL PRIMARY KEY,
  booking_id BIGINT NOT NULL,
  room_type_id BIGINT NOT NULL,
  physical_room_id BIGINT,
  quantity INT NOT NULL,
  price_per_night NUMERIC(12,2) NOT NULL,
  subtotal NUMERIC(12,2) NOT NULL
);

CREATE TABLE vouchers (
  voucher_id BIGSERIAL PRIMARY KEY,
  code VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(100),
  type voucher_type NOT NULL,
  value NUMERIC(12,2) NOT NULL,
  max_discount NUMERIC(12,2),
  min_booking_amount NUMERIC(12,2),
  usage_limit INT,
  used_count INT DEFAULT 0,
  valid_from TIMESTAMPTZ,
  valid_to TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE booking_vouchers (
  booking_id BIGINT NOT NULL,
  voucher_code VARCHAR(20) NOT NULL,
  discount_amount NUMERIC(12,2) NOT NULL,
  PRIMARY KEY (booking_id, voucher_code)
);

CREATE TABLE payments (
  payment_id BIGSERIAL PRIMARY KEY,
  booking_id BIGINT NOT NULL,
  amount NUMERIC(12,2) NOT NULL,
  method payment_method_type NOT NULL,
  status payment_status_type DEFAULT 'pending',
  transaction_id VARCHAR(100),
  gateway_response JSONB,
  refund_amount NUMERIC(12,2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE partner_payouts (
  payout_id BIGSERIAL PRIMARY KEY,
  hotel_id BIGINT NOT NULL,
  period_month DATE NOT NULL,
  total_commission NUMERIC(12,2) DEFAULT 0,
  total_payout NUMERIC(12,2) DEFAULT 0,
  status partner_payouts_status_type DEFAULT 'calculated',
  paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE payout_items (
  item_id BIGSERIAL PRIMARY KEY,
  payout_id BIGINT NOT NULL,
  booking_id BIGINT NOT NULL,
  commission_amount NUMERIC(12,2),
  payout_amount NUMERIC(12,2)
);

CREATE TABLE reviews (
  review_id BIGSERIAL PRIMARY KEY,
  booking_id BIGINT UNIQUE NOT NULL,
  hotel_id BIGINT NOT NULL,
  guest_id BIGINT NOT NULL,
  rating SMALLINT NOT NULL,
  comment TEXT,
  images JSONB DEFAULT '[]',
  is_verified BOOLEAN DEFAULT FALSE,
  status review_status_type DEFAULT 'published',
  created_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT chk_rating_range CHECK (rating BETWEEN 1 AND 5)
);

CREATE TABLE hotel_contracts (
  contract_id BIGSERIAL PRIMARY KEY,
  hotel_id BIGINT UNIQUE NOT NULL,
  contract_file VARCHAR(500),
  business_license_file VARCHAR(500),
  tax_code VARCHAR(20),
  bank_account JSONB,
  status hotel_contracts_status_type DEFAULT 'pending',
  rejection_reason TEXT,
  approved_by BIGINT,
  approved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE refresh_tokens (
  refresh_id BIGSERIAL PRIMARY KEY,
  user_type user_type_enum NOT NULL,
  user_id BIGINT NOT NULL,
  token_hash VARCHAR(255) UNIQUE NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  revoked BOOLEAN DEFAULT FALSE,
  user_agent VARCHAR(255),
  ip_address VARCHAR(45),
  created_at TIMESTAMPTZ DEFAULT now(),
  last_used_at TIMESTAMPTZ
);

CREATE TABLE audit_logs (
  log_id BIGSERIAL PRIMARY KEY,
  actor_type actor_type_enum NOT NULL,
  actor_id BIGINT,
  action VARCHAR(50) NOT NULL,
  resource_type VARCHAR(50),
  resource_id BIGINT,
  hotel_id BIGINT,
  status VARCHAR(20) NOT NULL,
  message TEXT,
  ip_address VARCHAR(45),
  user_agent VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE complaints (
  complaint_id BIGSERIAL PRIMARY KEY,
  actor_type actor_type_enum NOT NULL,
  actor_id BIGINT NOT NULL,
  booking_id BIGINT,
  review_id BIGINT,
  payment_id BIGINT,
  category complaint_category_type NOT NULL,
  status complaint_status_type DEFAULT 'open',
  description TEXT NOT NULL,
  resolution_note TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE conversations (
  conversation_id BIGSERIAL PRIMARY KEY,
  hotel_id BIGINT,
  guest_id BIGINT,
  subject VARCHAR(255),
  last_message_at TIMESTAMPTZ,
  unread_for_guest INT DEFAULT 0,
  unread_for_partner INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE messages (
  message_id BIGSERIAL PRIMARY KEY,
  conversation_id BIGINT NOT NULL,
  sender_type sender_type_enum NOT NULL,
  sender_id BIGINT,
  content TEXT,
  attachments JSONB DEFAULT '[]',
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Foreign keys (added after table creation to avoid ordering/circular issues)
ALTER TABLE staff
  ADD CONSTRAINT fk_staff_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE SET NULL;

ALTER TABLE hotels
  ADD CONSTRAINT fk_hotels_owner_staff FOREIGN KEY (owner_id) REFERENCES staff(staff_id) ON DELETE RESTRICT;

ALTER TABLE room_types
  ADD CONSTRAINT fk_room_types_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE CASCADE;

ALTER TABLE physical_rooms
  ADD CONSTRAINT fk_physical_rooms_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_physical_rooms_room_type FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) ON DELETE CASCADE;

ALTER TABLE room_rates
  ADD CONSTRAINT fk_room_rates_room_type FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) ON DELETE CASCADE;

ALTER TABLE room_holds
  ADD CONSTRAINT fk_room_holds_guest FOREIGN KEY (guest_id) REFERENCES guests(guest_id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_room_holds_room_type FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) ON DELETE CASCADE;

ALTER TABLE bookings
  ADD CONSTRAINT fk_bookings_guest FOREIGN KEY (guest_id) REFERENCES guests(guest_id) ON DELETE RESTRICT,
  ADD CONSTRAINT fk_bookings_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE RESTRICT;

ALTER TABLE booking_rooms
  ADD CONSTRAINT fk_booking_rooms_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_booking_rooms_room_type FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) ON DELETE RESTRICT,
  ADD CONSTRAINT fk_booking_rooms_physical_room FOREIGN KEY (physical_room_id) REFERENCES physical_rooms(physical_room_id) ON DELETE SET NULL;

ALTER TABLE booking_vouchers
  ADD CONSTRAINT fk_booking_vouchers_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_booking_vouchers_voucher FOREIGN KEY (voucher_code) REFERENCES vouchers(code) ON DELETE RESTRICT;

ALTER TABLE payments
  ADD CONSTRAINT fk_payments_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE;

ALTER TABLE partner_payouts
  ADD CONSTRAINT fk_partner_payouts_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE CASCADE;

ALTER TABLE payout_items
  ADD CONSTRAINT fk_payout_items_payout FOREIGN KEY (payout_id) REFERENCES partner_payouts(payout_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_payout_items_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE RESTRICT;

ALTER TABLE reviews
  ADD CONSTRAINT fk_reviews_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_reviews_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_reviews_guest FOREIGN KEY (guest_id) REFERENCES guests(guest_id) ON DELETE RESTRICT;

ALTER TABLE hotel_contracts
  ADD CONSTRAINT fk_hotel_contracts_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_hotel_contracts_approved_by FOREIGN KEY (approved_by) REFERENCES staff(staff_id) ON DELETE SET NULL;

ALTER TABLE refresh_tokens
  -- no FK to users, user_type/user_id handled at application level
  ;

ALTER TABLE audit_logs
  ;

ALTER TABLE complaints
  ADD CONSTRAINT fk_complaints_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_complaints_review FOREIGN KEY (review_id) REFERENCES reviews(review_id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_complaints_payment FOREIGN KEY (payment_id) REFERENCES payments(payment_id) ON DELETE SET NULL;

ALTER TABLE conversations
  ADD CONSTRAINT fk_conversations_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_conversations_guest FOREIGN KEY (guest_id) REFERENCES guests(guest_id) ON DELETE SET NULL;

ALTER TABLE messages
  ADD CONSTRAINT fk_messages_conversation FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE;

-- Add FK for staff_roles after staff table exists
ALTER TABLE staff_roles
  ADD CONSTRAINT fk_staff_roles_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE;

-- Indexes
CREATE INDEX idx_guests_email ON guests(email);
CREATE INDEX idx_guests_phone ON guests(phone);
-- Partial unique for provider/provider_id when provider_id is set
CREATE UNIQUE INDEX ux_guests_provider_providerid ON guests(provider, provider_id) WHERE provider_id IS NOT NULL;

CREATE INDEX idx_staff_email ON staff(email);
CREATE INDEX idx_staff_role ON staff(role);
CREATE INDEX idx_staff_hotel_id ON staff(hotel_id);

CREATE INDEX idx_hotels_city ON hotels(city);
CREATE INDEX idx_hotels_status ON hotels(status);
CREATE INDEX idx_hotels_owner_id ON hotels(owner_id);

CREATE INDEX idx_room_types_hotel_id ON room_types(hotel_id);

CREATE INDEX idx_physical_rooms_hotel_id ON physical_rooms(hotel_id);
CREATE INDEX idx_physical_rooms_room_type_id ON physical_rooms(room_type_id);
CREATE UNIQUE INDEX ux_physical_room_number_hotel ON physical_rooms(room_number, hotel_id);

CREATE UNIQUE INDEX ux_room_rates_room_type_date ON room_rates(room_type_id, date);

CREATE INDEX idx_room_holds_session_id ON room_holds(session_id);
CREATE INDEX idx_room_holds_expires_at ON room_holds(expires_at);
CREATE INDEX idx_room_holds_room_type_dates ON room_holds(room_type_id, check_in, check_out);

CREATE INDEX idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX idx_bookings_hotel_id ON bookings(hotel_id);

CREATE INDEX idx_booking_rooms_booking_id ON booking_rooms(booking_id);

CREATE INDEX idx_payments_booking_id ON payments(booking_id);

CREATE INDEX idx_refresh_tokens_user_type_id ON refresh_tokens(user_type, user_id);
CREATE INDEX idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);

CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- Additional suggestions: partitioning, full text indexes, etc. (not applied here)

-- End of DDL
